## OPENGL

OpenGL is a requird dependency for this project to compile and run.

### Ubuntu 22.04 

Here are the steps to install OpenGL3 on Ubuntu 22.04:

1. Update your system packages and install some dependencies by running the following commands in your terminal:

    ```bash
    sudo apt update
    sudo apt install cmake pkg-config
    sudo apt install mesa-utils libglu1-mesa-dev freeglut3-dev mesa-common-dev
    sudo apt install libglew-dev libglfw3-dev libglm-dev
    sudo apt install libao-dev libmpg123-dev
    ```

2. Install GLFW, a library that helps you create and manage windows and handle input events. You can download the source code from GitHub⁸ and compile it yourself, or use the following commands to install it from the repository:

    ```bash
    cd /usr/local/lib/
    git clone https://github.com/glfw/glfw.git
    cd glfw
    cmake .
    make
    sudo make install
    ```

3. Install GLAD, a library that loads the OpenGL functions at run-time. You can use the online service to generate the GLAD files for your desired OpenGL version and profile. For example, you can choose OpenGL 3.3 and Core profile, and download the zip file. Then, extract the files and copy them to your project directory.

4. Write a simple C++ program that uses OpenGL to draw a triangle on the screen. You can use any text editor or IDE of your choice, such as Visual Studio Code. You can also use an example program from this website or this video¹. Save your file as `main.cpp` in your project directory.

5. Compile and run your program using the following commands in your terminal:

    ```bash
    g++ main.cpp -o main -lGL -lGLU -lglfw -lGLEW -ldl
    ./main
    ```