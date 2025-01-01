#include <sys/socket.h>
#include <arpa/inet.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>

int main() {
    /* 1. Create socket */
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
                     // use IPv4  use TCP

    /* 2. Construct server address */
    struct sockaddr_in serveraddr;
    serveraddr.sin_family = AF_INET; // use IPv4
    serveraddr.sin_addr.s_addr = INADDR_ANY;
    // Set sending port
    int SEND_PORT = 8080;
    serveraddr.sin_port = htons(SEND_PORT); // Big endian

    /* 3. Connect to server */
    int did_connect = connect(sockfd, (struct sockaddr*) &serveraddr, 
                           // socket   server info
                              sizeof(serveraddr));
    // Error if did_connect < 0 :(
    if (did_connect < 0) return errno;

    /* 4. Send data to server */
    char client_buf[] = "Hello world!";
    int did_send = send(sockfd, client_buf, strlen(client_buf), 0);
                     // socket  send data   how much to send  flags
    // Error if did_send < 0 :(
    if (did_send < 0) return errno;

    /* 5. Create buffer to store incoming data */
    int BUF_SIZE = 1024;
    char server_buf[BUF_SIZE];

    /* 6. Listen for response from server */
    int bytes_recvd = recv(sockfd, server_buf, BUF_SIZE, 0);
                        // socket  store data  how much  flags
    // Execution will stop here until `BUF_SIZE` is read or termination/error
    // Error if bytes_recvd < 0 :(
    if (bytes_recvd < 0) return errno;
    // Print out data
    write(1, server_buf, bytes_recvd);

    /* 7. You're done! Terminate the connection */     
    close(sockfd);
    return 0;
}