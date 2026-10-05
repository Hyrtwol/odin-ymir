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

Bind_Buffer_Target :: enum u32 {
	ARRAY_BUFFER         = gl.ARRAY_BUFFER,
	ELEMENT_ARRAY_BUFFER = gl.ELEMENT_ARRAY_BUFFER,
}

Bind_Buffer_Usage :: enum u32 {
	STATIC_DRAW  = gl.STATIC_DRAW,
	DYNAMIC_DRAW = gl.DYNAMIC_DRAW,
}

Bind_Buffer :: struct {
	target: Bind_Buffer_Target,
	buffer: u32,
}

gen_bind_buffer :: proc(target: Bind_Buffer_Target) -> (bb: Bind_Buffer) {
	bb.target = target
	gl.GenBuffers(1, &bb.buffer)
	return
}

delete_bind_buffer :: proc(bb: ^Bind_Buffer) {
	gl.DeleteBuffers(1, &bb.buffer)
}

/*gen_buffers :: proc {
	gl.GenBuffers,
	gen_bind_buffer,
}*/

bind_buffer :: proc(bb: Bind_Buffer) {
	gl.BindBuffer(u32(bb.target), bb.buffer)
	return
}

bind_buffer_data :: proc(bb: Bind_Buffer, indices: []$T, usage: Bind_Buffer_Usage = .STATIC_DRAW) {
	gl.BufferData(u32(bb.target), len(indices) * size_of(indices[0]), raw_data(indices), u32(usage))
	return
}

Vertex_Array_Type :: enum u32 {
	UNSIGNED_SHORT = gl.UNSIGNED_SHORT,
	UNSIGNED_INT   = gl.UNSIGNED_INT,
}

Vertex_Array :: struct {
	type:  Vertex_Array_Type,
	array: u32,
}

gen_vertex_array :: proc(type: Vertex_Array_Type = .UNSIGNED_INT) -> (va: Vertex_Array) {
	va.type = type
	gl.GenVertexArrays(1, &va.array)
	return
}

delete_vertex_array :: proc(va: ^Vertex_Array) {
	gl.DeleteVertexArrays(1, &va.array)
}

bind_vertex_array :: proc(va: Vertex_Array) {
	gl.BindVertexArray(va.array)
	return
}


Texture_Target :: enum u32 {
	TEXTURE_2D = gl.TEXTURE_2D,
}

Texture :: struct {
	target:  Texture_Target,
	texture: u32,
}

gen_texture :: proc(target: Texture_Target = .TEXTURE_2D) -> (texture: Texture) {
	texture.target = target
	gl.GenTextures(1, &texture.texture)
	return
}

delete_texture :: proc(texture: ^Texture) {
	gl.DeleteTextures(1, &texture.texture)
}

gen_textures :: proc() -> (textures: [dynamic]Texture) {
	textures = make([dynamic]Texture, 0)
	return
}

delete_textures :: proc(textures: ^[dynamic]Texture) {
	for &texture in textures {
		delete_texture(&texture)
	}
	delete(textures^)
}

bind_texture :: proc(texture: Texture) {
	gl.BindTexture(u32(texture.target), texture.texture)
}

tex_image_2D :: proc(texture: Texture, level, internalformat: i32, size: [2]i32, format, type: u32, pixels: []u8) {
	gl.TexImage2D(
		u32(texture.target), // texture type
		level, // level of detail number (default = 0)
		internalformat, // texture format
		**size, // width, height
		0, // border, must be 0
		format, // pixel data format
		type, // data type of pixel data
		raw_data(pixels), // image data
	)
}

generate_mipmap :: proc(texture: Texture) {
	gl.GenerateMipmap(u32(texture.target))
}

tex_parameteri :: proc(texture: Texture, pname: u32, param: i32) {
	gl.TexParameteri(u32(texture.target), pname, param)
}
