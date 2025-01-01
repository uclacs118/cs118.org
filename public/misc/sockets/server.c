#include <sys/socket.h>
#include <arpa/inet.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>

int main() {
    /* 1. Create socket */
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
                     // use IPv4  use UDP

    /* 2. Construct our address */
    struct sockaddr_in servaddr;
    servaddr.sin_family = AF_INET; // use IPv4
    servaddr.sin_addr.s_addr = INADDR_ANY; // accept all connections
                            // same as inet_addr("0.0.0.0") 
                                     // "Address string to network bytes"
    // Set receiving port
    int PORT = 8080;
    servaddr.sin_port = htons(PORT); // Big endian

    /* 3. Let operating system know about our config */
    int did_bind = bind(sockfd, (struct sockaddr*) &servaddr, 
                        sizeof(servaddr));
    // Error if did_bind < 0 :(
    if (did_bind < 0) return errno;

    /* 4. Create buffer to store incoming data */
    int BUF_SIZE = 1024;
    char client_buf[BUF_SIZE];
    struct sockaddr_in clientaddr = {0}; // Same information, but about client
    socklen_t clientsize = sizeof(clientaddr);

    /* 5. Listen for data from clients */
    int bytes_recvd = recvfrom(sockfd, client_buf, BUF_SIZE, 
                            // socket  store data  how much
                               0, (struct sockaddr*) &clientaddr, 
                               &clientsize);
    // Execution will stop here until `BUF_SIZE` is read or termination/error
    // Error if bytes_recvd < 0 :(
    if (bytes_recvd < 0) return errno;

    /* 6. Inspect data from client */
    char* client_ip = inet_ntoa(clientaddr.sin_addr);
                    // "Network bytes to address string"
    int client_port = ntohs(clientaddr.sin_port); // Little endian
    // Print out data
    write(1, client_buf, bytes_recvd);

    /* 7. Send data back to client */
    char server_buf[] = "Hello world!";
    int did_send = sendto(sockfd, server_buf, strlen(server_buf), 
                       // socket  send data   how much to send
                          0, (struct sockaddr*) &clientaddr, 
                       // flags   where to send
                          sizeof(clientaddr));
    if (did_send < 0) return errno;
    

    /* 8. You're done! Terminate the connection */     
    close(sockfd);
    return 0;
}
