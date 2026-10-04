// https://wikis.khronos.org/opengl
package ymir_gl

// odinfmt: disable
import "core:fmt"
import gl "vendor:OpenGL"
// odinfmt: enable

_ :: fmt

GetString :: gl.GetString

set_viewport_size :: proc(size: [2]i32) {
	gl.Viewport(0, 0, **size)
}

set_viewport :: proc {
	gl.Viewport,
	set_viewport_size,
}

// load_up_to :: gl.load_up_to
load_up_to :: proc(major, minor: int, set_proc_address: gl.Set_Proc_Address_Type) {
	assert(gl.impl_GetString == nil)
	gl.load_up_to(major, minor, set_proc_address)
	assert(gl.impl_GetString != nil)
	assert(gl.impl_DrawArrays != nil)
	assert(gl.impl_GenBuffers != nil)
}
