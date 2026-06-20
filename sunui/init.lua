--
local ffi = require("ffi")

ffi.cdef[[
    typedef struct SDL_Window SDL_Window;
    typedef struct SDL_Renderer SDL_Renderer;
    
    typedef struct SDL_Rect { int x, y, w, h; } SDL_Rect;

    // Expand the mappings so Lua can read exact coordinate fields
    typedef struct SDL_MouseMotionEvent {
        uint32_t type; uint32_t timestamp; uint32_t windowID; uint32_t which;
        uint32_t state; int32_t x; int32_t y; int32_t xrel; int32_t yrel;
    } SDL_MouseMotionEvent;

    typedef struct SDL_MouseButtonEvent {
        uint32_t type; uint32_t timestamp; uint32_t windowID; uint32_t which;
        uint8_t button; uint8_t state; uint8_t clicks; uint8_t padding1;
        int32_t x; int32_t y;
    } SDL_MouseButtonEvent;

    typedef union SDL_Event {
        uint32_t type;
        SDL_MouseMotionEvent motion;
        SDL_MouseButtonEvent button;
        uint8_t padding[56];
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

local lib_name = ffi.os == "Windows" and "SDL2.dll" or (ffi.os == "OSX" and "libSDL2.dylib" or "libSDL2")
local SDL = ffi.load(lib_name)

return {
    lib = SDL,
    INIT_VIDEO = 0x00000020,
    WINDOW_SHOWN = 0x00000004,
    RENDERER_ACCELERATED = 0x00000002,
    QUIT = 0x100,
    MOUSEMOTION = 0x400,
    MOUSEBUTTONDOWN = 0x401,
    MOUSEBUTTONUP = 0x402
}
