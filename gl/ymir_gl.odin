// https://wikis.khronos.org/opengl
package ymir_gl

import "core:fmt"
import gl "vendor:OpenGL"

_ :: fmt

GetString :: gl.GetString

set_viewport_size :: proc(size: [2]i32) {
	gl.Viewport(0, 0, **size)
}

set_viewport :: proc {
	gl.Viewport,
	set_viewport_size,
}
