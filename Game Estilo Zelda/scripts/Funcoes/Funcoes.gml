// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Funcoes(){

}
///@function desenha_sombra(sprite, escala, [cor], [alpha])
function desenha_sombra(_sprite, _escala, _cor = c_white, _alpha = .2) {
	draw_sprite_ext(_sprite, 0, x, y, _escala, _escala, 0, _cor, _alpha);
}

//Sistema de profundidade
function ajusta_depth () {
	depth = -y;
}