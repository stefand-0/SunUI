local ffi = require("ffi")

ffi.cdef[[
    // Basic SDL Types
    typedef struct SDL_Window SDL_Window;
    typedef struct SDL_Renderer SDL_Renderer;
    typedef struct SDL_Texture SDL_Texture;
    typedef struct { int x, y, w, h; } SDL_Rect;
    typedef struct { uint8_t r, g, b, a; } SDL_Color;
    
    typedef struct {
        uint32_t format;
        int w, h, pitch;
        void *pixels;
        void *userdata;
        int locked;
        void *list_blits;
        SDL_Rect clip_rect;
        void *map;
        int refcount;
    } SDL_Surface;

    // SDL Mouse Event Structures
    typedef struct { uint32_t type; uint32_t timestamp; uint32_t windowID; uint32_t which; uint32_t state; int32_t x; int32_t y; int32_t xrel; int32_t yrel; } SDL_MouseMotionEvent;
    typedef struct { uint32_t type; uint32_t timestamp; uint32_t windowID; uint32_t which; uint8_t button; uint8_t state; uint8_t clicks; uint8_t padding1; int32_t x; int32_t y; } SDL_MouseButtonEvent;
    
    typedef union {
        uint32_t type;
        SDL_MouseMotionEvent motion;
        SDL_MouseButtonEvent button;
        uint8_t padding[56];
    } SDL_Event;

    // Core SDL Functions
    int SDL_Init(uint32_t flags);
    SDL_Window* SDL_CreateWindow(const char *title, int x, int y, int w, int h, uint32_t flags);
    SDL_Renderer* SDL_CreateRenderer(SDL_Window *window, int index, uint32_t flags);
    int SDL_PollEvent(SDL_Event *event);
    int SDL_SetRenderDrawColor(SDL_Renderer *renderer, uint8_t r, uint8_t g, uint8_t b, uint8_t a);
    int SDL_RenderClear(SDL_Renderer *renderer);
    int SDL_RenderFillRect(SDL_Renderer *renderer, const SDL_Rect *rect);
    void SDL_RenderPresent(SDL_Renderer *renderer);
    SDL_Texture* SDL_CreateTextureFromSurface(SDL_Renderer *renderer, SDL_Surface *surface);
    int SDL_RenderCopy(SDL_Renderer *renderer, SDL_Texture *texture, const SDL_Rect *srcrect, const SDL_Rect *dstrect);
    void SDL_DestroyTexture(SDL_Texture *texture);
    void SDL_FreeSurface(SDL_Surface *surface);
    void SDL_DestroyRenderer(SDL_Renderer *renderer);
    void SDL_DestroyWindow(SDL_Window *window);
    void SDL_Quit(void);

    // ==========================================
    // SDL_ttf Bindings
    // ==========================================
    typedef struct _TTF_Font TTF_Font;
    int TTF_Init(void);
    TTF_Font* TTF_OpenFont(const char *file, int ptsize);
    void TTF_CloseFont(TTF_Font *font);
    void TTF_Quit(void);
    SDL_Surface* TTF_RenderText_Blended(TTF_Font *font, const char *text, SDL_Color fg);
]]

-- Load libraries safely
local sdl_lib = ffi.load("SDL2")
local ttf_lib = ffi.load("SDL2_ttf")

-- Build unified reference lookup table
local M = {
    lib = setmetatable({}, {
        __index = function(_, key)
            local status, val = pcall(function() return sdl_lib[key] end)
            if status then return val end
            return ttf_lib[key]
        end
    }),
    constants = {
        INIT_VIDEO          = 0x00000020,
        WINDOW_SHOWN        = 0x00000004,
        RENDERER_ACCELERATED= 0x00000002,
        QUIT                = 0x100,
        MOUSEMOTION         = 0x400,
        MOUSEBUTTONDOWN     = 0x401,
        MOUSEBUTTONUP       = 0x402
    }
}

return M
