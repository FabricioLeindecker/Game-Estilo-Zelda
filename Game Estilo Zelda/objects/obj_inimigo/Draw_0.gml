/// @description Insert description here

//Desenha a sombra
if (image_index > 1) {
	tam_sombra = .7;	
}

//Se desenha
draw_self();

//Debug
if (global.debug) {
	draw_set_halign(1);
	draw_set_valign(1);
	draw_text(x, y - sprite_height, estado);	
	draw_set_halign(-1);
	draw_set_valign(-1);
	draw_circle(destino_x, destino_y, 16, false);
	draw_circle(x, y, campo_visao, true);
}





