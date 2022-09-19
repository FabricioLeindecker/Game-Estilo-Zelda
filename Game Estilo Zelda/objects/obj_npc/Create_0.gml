/// @description Insert description here

//Variáveis
larg	= 30;
alt		= 20; 
margem	= 5;

//Debug
debug_area = function() {
	var _y = bbox_bottom + margem;									//Pega a posição em Y
	draw_rectangle(x - larg /2, _y, x + larg /2, _y + alt, true);	//Desenha um retangulo para debug
}

//Area de dialogo com o NPC
dialogo_area = function() {
	var _y		= bbox_bottom + margem;	//Posição y 
	var _player = collision_rectangle(x - larg /2, _y, x + larg /2, _y + alt, obj_player, 0, 1);	//Área de colisão
	
	//image_blend = c_white;	debug
	if (_player) {
		//image_blend = c_red;	debug
		if (keyboard_check_pressed(vk_space)) {
			with(_player) {								//Eventos com o objeto player
				if (estado != "dialogo") {				//Se o estado for diferente do estado diálogo	
					estado		= "entrando no dialogo";//Vai para o estado entrando no diálogo	
					npc_dialago = other.id;				//Muda a variável do objeto player 
				}
			}		
		}
		if (keyboard_check_pressed(vk_escape)) {	//Se pressionar a tecla esc
			with(_player) {							//Evento do objeto player
				estado = "parado";					//Vai para o estado parado
			}
		}
	}
}


