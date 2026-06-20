--
local ffi = require("ffi")

-- Tell LuaJIT what C structures and functions it needs
ffi.cdef[[
    typedef struct SDL_Window SDL_Window;
    typedef struct SDL_Renderer SDL_Renderer;
    
    typedef struct SDL_Rect {
        int x, y;
        int w, h;
    } SDL_Rect;

    typedef union SDL_Event {
        uint32_t type;
        uint8_t padding[56]; -- Covers the size of any event structure
    } SDL_Event;

    int SDL_Init(uint32_t flags);
    SDL_Window* SDL_CreateWindow(const char* title, int x, int y, int w, int h, uint32_t flags);
    SDL_Renderer* SDL_CreateRenderer(SDL_Window* window, int index, uint32_t flags);
    
    int SDL_SetRenderDrawColor(SDL_Renderer* renderer, uint8_t r, uint8_t g, uint8_t b, uint8_t a);
    int SDL_RenderClear(SDL_Renderer* renderer);
    int SDL_RenderFillRect(SDL_Renderer* renderer, const SDL_Rect* rect);
    void SDL_RenderPresent(SDL_Renderer* renderer);
    
    int SDL_PollEvent(SDL_Event* event);
    void SDL_DestroyRenderer(SDL_Renderer* renderer);
    void SDL_DestroyWindow(SDL_Window* window);
    void SDL_Quit(void);
]]

-- Load the actual binary library file based on the OS
local lib_name = "SDL2"
if ffi.os == "Windows" then lib_name = "SDL2.dll" end
if ffi.os == "OSX" then lib_name = "libSDL2.dylib" end

local SDL = ffi.load(lib_name)

-- Map common SDL constants
return {
    lib = SDL,
    INIT_VIDEO = 0x00000020,
    WINDOW_SHOWN = 0x00000004,
    RENDERER_ACCELERATED = 0x00000002,
    QUIT = 0x100
}
