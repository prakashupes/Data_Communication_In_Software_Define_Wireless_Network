#ifndef LOG
# define LOG

///// header log.h ///////////
#include <string>
#include <fstream>

namespace log
{
    extern const std::string path ;
    
    
    extern std::ofstream out ;
    void flush() ;
}

//////// implementation log.cpp ///////////
// #include "log.h"
#include <ctime>

namespace log
{
    void flush() { out.flush() ; }

    namespace // detail
    {
        std::string time_stamp()
        {
            const auto now = std::time(nullptr) ;
            char cstr[256] {};
            return std::strftime( cstr, sizeof(cstr), "%Y_%m_%d_%H:%M:%S", std::localtime(&now) ) ? cstr : "" ;
        }

        std::string path_to_session_log_file()
        {
          static const std::string log_dir = "/home/prakash/Github/Data_Communication_In_Software_Define_Wireless_Network/src/cpp/logs/" ;
            static const std::string log_file_name = "output.log" ;
           // return log_dir + time_stamp() +'_' + log_file_name ; if want to save log file with time_stamp
           
            return log_dir +'_' + log_file_name ;
        }
    }

   const std::string path = path_to_session_log_file() ;
   std::ofstream out = std::ofstream( path );
}

//////////// usage main.cpp ///////////////
// #include "log.h"
/*
#include <iostream>

int main()
{
    std::cout << "path: " << log::path << '\n' ;
    log::out << "this is a test\n" ;
    log::out << "this is another test\n" ;
    log::flush() ;
   // std::cout << "\n--------------------\n" << std::ifstream( log::path ).rdbuf() ;
    
    log::out << "this is the third test\n" ;
    log::flush() ;
    //std::cout << "\n--------------------\n" << std::ifstream( log::path ).rdbuf() ;
}
*/


#endif //LOG
