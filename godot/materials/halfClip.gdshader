shader_type spatial;

uniform float clip_distance;
uniform vec4 albedo : source_color;

void fragment() {
	vec4 world_vertex = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	world_vertex /= world_vertex.w;
    float distance_to_camera = distance(world_vertex.xz, CAMERA_POSITION_WORLD.xz);
	//ALBEDO = vec3(clamp( 1. * (distance_to_camera - clip_distance) / .1, 0., 1.),0.,0.);
	ALBEDO = albedo.xyz;
	//ALPHA = clamp( 1. * (distance_to_camera - clip_distance) / .1, 0., 1.);

    if (distance_to_camera < clip_distance) {
		discard;
    }
}

//shader_type spatial;
//render_mode blend_mix, depth_draw_opaque, unshaded;
//
//uniform float clip_start = 0.5;
//uniform float clip_end = 1.;
//
//void fragment() {
    //// Calculate view-space position
    //vec3 view_pos = (VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
    //float cam_z = -view_pos.z; // Positive distance from camera
//
    //float alpha = smoothstep(clip_start, clip_end, cam_z);
    //ALBEDO = vec3(1.0);
    //ALPHA = alpha;
//
    //if (alpha < 0.01) {
        //discard;
    //}
//}
