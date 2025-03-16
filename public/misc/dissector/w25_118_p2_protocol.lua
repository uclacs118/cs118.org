-- P1 protocol
simple_protocol = Proto("reliable_transport",  "Protocol for W25 CS118 Project 1")
-- Reliable Transport fields
sequence_number = ProtoField.uint16("transport.sequence_number", "sequence_number", base.DEC)
acknowledgment_number = ProtoField.uint32("transport.acknowledgment_number", "acknowledgment_number", base.DEC)
payload_len = ProtoField.uint16("transport.payload_len", "payload_len", base.DEC)
window_len = ProtoField.uint16("transport.window_len", "window_len", base.DEC)
flag_sync = ProtoField.uint16("transport.flag.sync", "sync", base.DEC, NULL, 0x1)
flag_ack = ProtoField.uint16("transport.flag.ack", "ack", base.DEC, NULL, 0x2)
flag_parity = ProtoField.uint16("transport.flag.parity", "parity", base.DEC, NULL, 0x4)
-- payload content as bytes and as string
payload_byte = ProtoField.bytes("transport.payload_byte", "payload_byte", base.SPACE)
payload_str = ProtoField.string("transport.payload_str", "payload_str")
-- set fields
simple_protocol.fields = { sequence_number, acknowledgment_number, payload_len, window_len, flag_sync, flag_ack, flag_parity, payload_byte, payload_str }

-- P2 protocol
secure_protocol = Proto("secure_transport",  "Security layer of W25 CS118 Project 2")
-- TLV Header
secure_tlv_type = ProtoField.uint8("secure.msg_tlv_type", "tlv_type", base.DEC)
secure_tlv_type_name = ProtoField.string("transport.msg_tlv_typename", "tlv_typename")
secure_tlv_len = ProtoField.uint16("secure.msg_tlv_len", "tlv_len", base.DEC)
secure_tlv_payload = ProtoField.bytes("transport.payload_byte", "payload_byte", base.SPACE)
secure_protocol.fields = { secure_tlv_type, secure_tlv_type_name, secure_tlv_len, secure_tlv_payload }

function secure_protocol_dissector(buffer, pinfo, tree)
    -- retrieve buffer length
    length = buffer:len()
    -- filter empty packets
    if length == 0 then
        return
    end

    -- Set protocol name
    pinfo.cols.protocol = secure_protocol.name
    -- Add protocol to tree
    local subtree = tree:add(secure_protocol, buffer(), "Secure Protocol")

    tlv_parser(buffer, pinfo, subtree)
end

function tlv_parser(buffer, pinfo, tree)
    -- retrieve buffer length
    local length = buffer:len()
    print(length)
    -- filter empty packets
    if length == 0 then
        return
    end
    -- extract tlv length
    local tlvlength = 0
    local base = 1
    local len_len = 1
    if buffer(1,1):uint() == 0xFD then
        tlvlength = buffer(2,2):uint()
        base = 4
        len_len = 2
    else
        tlvlength = buffer(1,1):uint()
        base = 2
        len_len = 1
    end

    -- extract tlv type
    local tlvtype = tonumber(buffer(0,1):uint())

    local type_map = {
        [0x1] = "NONCE",
        [0x2] = "PUBLIC_KEY",
        [0x10] = "CLIENT_HELLO",
        [0xA0] = "CERTIFICATE",
        [0xA1] = "DNS_NAME",
        [0xA2] = "SIGNATURE",
        [0x20] = "SERVER_HELLO",
        [0x21] = "HANDSHAKE_SIGNATURE",
        [0x30] = "FINISHED",
        [0x04] = "TRANSCRIPT",
        [0x50] = "DATA",
        [0x51] = "IV",
        [0x52] = "CIPHERTEXT",
        [0x53] = "MAC"
    }

    local type_name = type_map[tlvtype] or "default"

    local subtree = tree:add(secure_protocol, buffer(), type_name)
    subtree:add(secure_tlv_type, buffer(0,1))
    subtree:add(secure_tlv_type_name, type_name)
    subtree:add(secure_tlv_len, buffer(1, len_len))
    subtree:add(secure_tlv_payload, buffer(base, tlvlength))

    if  type_name == "DATA" or 
        type_name == "FINISHED" or 
        type_name == "CERTIFICATE" or
        type_name == "CLIENT_HELLO" or
        type_name == "SERVER_HELLO" then
            -- descend down to parse nested payload
            tlv_parser(buffer(base, tlvlength), pinfo, subtree)
    end

    if base+tlvlength >= length then
        return
    end
    -- Continue parsing forward if possible
    tlv_parser(buffer(base+tlvlength, length-(base+tlvlength)), pinfo, tree)
end

function simple_protocol.dissector(buffer, pinfo, tree)
    -- retrieve buffer length
    local length = buffer:len()
    -- filter empty packets
    if length == 0 then
        return
    end
    -- Set protocol name
    pinfo.cols.protocol = simple_protocol.name
    -- Add protocol to tree
    local subtree = tree:add(simple_protocol, buffer(), "Reliable Transport Protocol")
    -- Add fields to tree
    subtree:add(sequence_number, buffer(0, 2))
    subtree:add(acknowledgment_number, buffer(2, 2))
    subtree:add(payload_len, buffer(4, 2))
    subtree:add(window_len, buffer(6, 2))
    subtree:add_le(flag_sync, buffer(8, 2))
    subtree:add_le(flag_ack, buffer(8, 2))
    subtree:add_le(flag_parity, buffer(8, 2))
    subtree:add(payload_byte, buffer(12, length - 12)) -- Remove header
    subtree:add(payload_str, buffer(12, length - 12)) -- Remove header
    if buffer:range(8, 2):uint() == 0 then
        return
    end
    secure_protocol_dissector(buffer(12, length-12), pinfo, tree)
end

-- Match protocol by UDP port
local udp_port = DissectorTable.get("udp.port")
for port = 7080, 7100 do
    udp_port:add(port, simple_protocol)
  end

for port = 8080, 8100 do
    udp_port:add(port, simple_protocol)
end