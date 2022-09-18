/// @description Insert description here

//Desenha a sombra
desenha_sombra(spr_sombra, tam_sombra, , .2);

//Se desenha
draw_sprite_ext(sprite, image_ind, x, y, xscale, image_yscale, image_angle, image_blend, image_alpha);

//Desenhas os debugs do state machine
if (debug) {
	draw_set_halign(1);
	draw_set_valign(1);
	draw_text(x, y - sprite_height * 2, estado_txt);	
	draw_set_halign(-1);
	draw_set_valign(-1);
}
