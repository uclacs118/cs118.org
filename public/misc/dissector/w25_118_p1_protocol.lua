-- protocol
simple_protocol = Proto("reliable_transport",  "Protocol for W25 CS118 Project 1")
-- fields
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

simple_protocol.fields = { sequence_number, acknowledgment_number, payload_len, window_len, flag_sync, flag_ack, flag_parity, payload_byte, payload_str }

function simple_protocol.dissector(buffer, pinfo, tree)
    -- retrieve buffer length
    length = buffer:len()
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
end
-- Match protocol by UDP port
local udp_port = DissectorTable.get("udp.port")
for port = 7080, 7100 do
    udp_port:add(port, simple_protocol)
  end

for port = 8080, 8100 do
    udp_port:add(port, simple_protocol)
end