#include <practice_project/hello_world_header.h>

namespace practice {
	void hello_world(uint32_t arg1, uint32_t arg2){
		std::cout << fmt::format("Hello World. Input args: arg1 = {}, arg2 = {}", arg1, arg2);
	}
}