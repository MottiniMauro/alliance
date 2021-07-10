#ifndef __SOCKET_H__
#define __SOCKET_H__


#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <unistd.h>
#include <string>
#include <arpa/inet.h>
#include <vector>

namespace toroco {

    const int MAXHOSTNAME = 200;
    const int MAXCONNECTIONS = 5;
    const int MAXRECV = 5;//5 Mbyte
    const bool FASTMODE=true;

    class Socket
    {
        public:
            Socket();
            virtual ~Socket();

            // Server initialization
            bool Create();
            bool Bind(const int port, std::string ip = "any");
            bool Listen() const;
            bool Accept(Socket&) const;

            int Close();

            // Client initialization
            bool Connect (const std::string host, const int port);

            // Data Transimission
            bool Send(const std::string&) const;
            bool Send(const std::vector<char>*) const;
            bool Send(const std::vector<char>) const;
            bool Send(const char buffer[], size_t size) const;
            int  Recv(char buffer[], size_t size) const;

            void SetNonBlocking(const bool);

            bool isValid() const { return m_sock != -1; }

        private:
            int m_sock;
            sockaddr_in m_addr;
    };

};

#endif // __SOCKET_H__
