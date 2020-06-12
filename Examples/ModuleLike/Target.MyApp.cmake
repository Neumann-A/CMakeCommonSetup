TARGET_NAME
    MyMainApp
EXECUTABLE
SOURCES
    # *.cpp files and private headers (Headers are required for turning up in an IDE like VS)
    # Use generator expressions to conditional include or exclude files
PUBLIC_HEADERS # Headers which get installed
    # *.h list of public header files.
DEPENDS # default private depends
    GTest::GTest
PUBLIC_DEPENDS # public depends
INTERFACE_DEPENDS # interface depends
DEFINITIONS #Use PRIVATE INTERFACE and PUBLIC in a List