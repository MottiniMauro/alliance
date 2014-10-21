#include "SocketUdp.h"
#include "string.h"
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <iostream>
#include <sstream>
#include <netinet/tcp.h>
//#include <cstdint>


namespace toroco {

    SocketUDP::SocketUDP()
        : m_sock(-1)
    {
        memset(&m_addr, 0, sizeof(m_addr));
    }


    SocketUDP::~SocketUDP()
    {
        if (isValid())
            ::close( m_sock );
    }


    bool SocketUDP::Create()
    {
        m_sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);

        if (!isValid())
            return false;

        std::cout << "Socket create" << std::endl;

        return true;
    }


    bool SocketUDP::Bind(const int port, std::string ip)
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

    int SocketUDP::Close()
    {
        return ::close(m_sock);
    }


    bool SocketUDP::Send(const std::string& s) const
    {
        int status = ::sendto(m_sock, s.c_str(), s.size(), 0, (struct sockaddr *)&m_addr, sizeof(m_addr));

        if ( status == -1 )
            return false;
        else
            return true;
    }

    bool SocketUDP::Send(const char buffer[], size_t size) const
    {
        int status = ::sendto(m_sock, buffer, size, 0, (struct sockaddr *)&m_addr, sizeof(m_addr));

        if ( status == -1 )
            return false;
        else
            return true;
    }

    bool SocketUDP::Send(const std::vector<char>* v) const
    {
    	int status = ::sendto(m_sock, v->data(), v->size(), 0, (struct sockaddr *)&m_addr, sizeof(m_addr));

		if ( status == -1 )
			return false;
		else
			return true;
    }

    bool SocketUDP::Send(const std::vector<char> v) const
    {
    	int status = ::sendto(m_sock, v.data(), v.size(), 0, (struct sockaddr *)&m_addr, sizeof(m_addr));

		if ( status == -1 )
			return false;
		else
			return true;
    }

    int SocketUDP::Recv(char buffer[], size_t size) const
    {
        socklen_t len = sizeof(m_addr);
		memset(buffer, 0, size);

		int byteCount = ::recvfrom(m_sock, buffer, size, 0, (struct sockaddr *)&m_addr, &len);

        //std::cout << "Recieved: " << buffer << std::endl;

        return byteCount;
    }


    bool SocketUDP::Connect(const std::string host, const int port)
    {
        if (!isValid())
            return false;

        memset((char *) &m_addr, 0, sizeof(m_addr));
        m_addr.sin_family = AF_INET;
        m_addr.sin_port = htons(port);
         
        if (inet_aton(host.c_str() , &m_addr.sin_addr) == 0) 
        {
            //return false;
        }

        return true;
    }
};
