/// @description Insert description here

//Debug
if (keyboard_check_released(vk_tab)) {
	global.debug = !global.debug;
}

//Efeito de escorregar no gelo
var _gelo = instance_place(x, y, obj_gelo);		//Verica se esta colidindo com o gelo
if (_gelo) {									//Se sim
	acel = _gelo.meu_acel;						//A aceleração passa a ser a aceleração do objeto gelo
}
else {
	acel = meu_acel;							//Se não volta para a aceleração normal
}

//Chama a função para controlar os estados do player
controla_estado();
