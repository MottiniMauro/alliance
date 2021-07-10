#include "Socket.h"
#include "string.h"
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <iostream>
#include <sstream>
#include <netinet/tcp.h>
//#include <cstdint>


namespace toroco {

    Socket::Socket()
        : m_sock(-1)
    {
        memset(&m_addr, 0, sizeof(m_addr));
    }


    Socket::~Socket()
    {
        if (isValid())
            ::close( m_sock );
    }


    bool Socket::Create()
    {
        m_sock = socket(AF_INET, SOCK_STREAM, 0);

        if (!isValid())
            return false;

        // TIME_WAIT - argh
        int on = 1;
        if (setsockopt(m_sock, SOL_SOCKET, SO_REUSEADDR, (const char*)&on, sizeof(on)) == -1)
            return false;
            
        if (setsockopt(m_sock, IPPROTO_TCP, TCP_NODELAY, (const char*)&on, sizeof(on)) == -1)
            return false;

        std::cout << "Socket create" << std::endl;

        return true;
    }


    bool Socket::Bind(const int port, std::string ip)
    {
        if (!isValid())
            return false;

        m_addr.sin_family = AF_INET;

        if (ip == "any")
            m_addr.sin_addr.s_addr = INADDR_ANY;
        else
            m_addr.sin_addr.s_addr = inet_addr(ip.c_str());

        m_addr.sin_port = htons(port);

        int bind_return = ::bind(m_sock, (struct sockaddr*) &m_addr, sizeof(m_addr));

        if (bind_return == -1)
            return false;

        std::cout << "Socket bind" << std::endl;

        return true;
    }


    bool Socket::Listen() const
    {
        if (!isValid())
            return false;

        int listen_return = ::listen (m_sock, MAXCONNECTIONS);

        if (listen_return == -1)
            return false;

        std::cout << "Socket listen" << std::endl;

        return true;
    }


    bool Socket::Accept(Socket& new_socket) const
    {
        int addr_length = sizeof(m_addr);

        new_socket.m_sock = ::accept(m_sock, (sockaddr*)&m_addr, (socklen_t*)&addr_length);

        std::cout << "Socket accept" << std::endl;

        if (new_socket.m_sock <= 0)
            return false;
        else
            return true;
    }


    int Socket::Close()
    {
        return ::close(m_sock);
    }


    bool Socket::Send(const std::string& s) const
    {
        int status = ::send(m_sock, s.c_str(), s.size(), MSG_NOSIGNAL);

        if ( status == -1 )
            return false;
        else
            return true;
    }

    bool Socket::Send(const char buffer[], size_t size) const
    {
        int status = ::send(m_sock, buffer, size, MSG_NOSIGNAL);

        if ( status == -1 )
            return false;
        else
            return true;
    }

    bool Socket::Send(const std::vector<char>* v) const
    {
    	int status = ::send(m_sock, v->data(), v->size(), MSG_NOSIGNAL);

		if ( status == -1 )
			return false;
		else
			return true;
    }

    bool Socket::Send(const std::vector<char> v) const
    {
    	int status = ::send(m_sock, v.data(), v.size(), MSG_NOSIGNAL);

		if ( status == -1 )
			return false;
		else
			return true;
    }

    int Socket::Recv(char buffer[], size_t size) const
    {
		memset(buffer, 0, size);

		int byteCount = ::recv(m_sock, buffer, size, 0);

        //std::cout << "Recieved: " << buffer << std::endl;

        return byteCount;
    }


    bool Socket::Connect(const std::string host, const int port)
    {
        if (!isValid())
            return false;

        /*m_addr.sin_family = AF_INET;
        m_addr.sin_port = htons(port);

        int status = inet_pton(AF_INET, host.c_str(), &m_addr.sin_addr);

        if (errno == EAFNOSUPPORT)
            return false;

        status = ::connect(m_sock, (sockaddr*)&m_addr, sizeof(m_addr));*/

        //obtenemos la direccion con getaddrinfo
        struct addrinfo hints, *res;
        memset(&hints, 0, sizeof hints);
        hints.ai_family = AF_INET;
        hints.ai_socktype = SOCK_STREAM;
        std::stringstream portString;
        portString << port;
        if (getaddrinfo(host.c_str(), portString.str().c_str(), &hints, &res) != 0)
            return false;

        //primitiva CONNECT
        int status = ::connect(m_sock, res->ai_addr, res->ai_addrlen);

        if (status == 0)
            return true;
        else
            return false;
    }


    void Socket::SetNonBlocking(const bool b)
    {
        int opts;

        opts = fcntl(m_sock, F_GETFL);

        if (opts < 0)
            return;

        if (b)
            opts = (opts | O_NONBLOCK);
        else
            opts = (opts & ~O_NONBLOCK);

        fcntl(m_sock, F_SETFL, opts);
    }

};
