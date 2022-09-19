/// @description Insert description here

//Herda os eventos do objeto pai
event_inherited()

//Se desenha
draw_sprite_ext(sprite, image_ind, x, y, xscale, image_yscale, image_angle, image_blend, image_alpha);

//Desenhas os debugs do state machine
if (global.debug) {
	draw_set_halign(1);
	draw_set_valign(1);
	draw_text(x, y - sprite_height * 2, estado_txt);	
	draw_set_halign(-1);
	draw_set_valign(-1);
}
