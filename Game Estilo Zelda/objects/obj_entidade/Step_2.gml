/// @description Insert description here

//Movimentação e colisão
//Eixo X
if (place_meeting(x + velh, y, obj_chao)) {				//Veridica se esta colidindo com o objeto chão
	var _chao = instance_place(x + velh, y, obj_chao);	//Verifica se ira colidir 
	if (_chao) {
		if (velh > 0) {									//Se a velocidade for maior que zero e for colidir
			x = _chao.bbox_left - sprite_width / 2;		//Trava a posição na esquerda
		}
		else if (velh < 0) {
			x = _chao.bbox_right + sprite_width / 2;	//Trava a posição na direita
		}
	}
	velh = 0;	//Se colidindo a velocidade é zerada
}
x += velh;		//Quando não colidindo pode se movimentar

//Eixo Y
var _chao = instance_place(x, y - velv, obj_chao);	
if (_chao) {										//Veridica se esta colidindo com o objeto chão
	if (velv > 0) {									//Se a velocidade for maior que zero e for colidir
		y = _chao.bbox_top - sprite_height / 2;		//Trava no topo
	}
	else if (velv < 0) {
		y = _chao.bbox_bottom - sprite_height / 2;	//Trava na posição inferior
	}
	velv = 0;	//Se colidindo a velocidade é zerada
}
y += velv;		//Quando não colidindo pode se movimentar

//Movimentação alternativa
/*Movimentação e colisão não precisa
if (place_meeting(x + velh, y, obj_chao)) {
	var _velh = sign(velh);
	while(!place_meeting(x + _velh, y, obj_chao)) {
		x += _velh;	
	}
	velh = 0;
}
x += round(velh);

if (place_meeting(x, y + velv, obj_chao)) {
	var _velv = sign(velv);
	while(!place_meeting(x, y + _velv, obj_chao)) {
		y += _velv;	
	}
	velv = 0;
}
y += round(velv);
*/
