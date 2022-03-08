#include <config.h>

/* Notes
 * 
 * Defining configurations -> Include the driver stuff using #include - this should be a precompiled library
 *  - needs a generic schema to follow -> struct with common members and a "dynamic" member determined by the included library
 *  - parsing and interpreting is up to a "driver" -> Specified by a function pointer
 *  - should be able to provide configuration for multiple drivers and files in the same thing.
 *
 * Building the configuration -> Compile configuration to a library
 *
 * Creating the configuration files -> Run this executable with a link to the library
 */

int main(int argc, char *argv[])
{
	/* Dynamically load a library (compiled configuration) during runtime because that's smart */

	return 0;
}

