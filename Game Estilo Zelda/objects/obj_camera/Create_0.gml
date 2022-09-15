/// @description Insert description here

//Variáveis
alvo	= noone;	//Nenhum alvo
estado	= noone;	//Nenhum estado

//Função para seguir o player
segue_player = function() {
	if (instance_exists(obj_player)) {	//Se o objeto player existir
		alvo = obj_player;				//O alvo é o player
	}
	else {
		estado = segue_nada;			//Se não existir não segue nada
	}
	
	//Posicionamento da camera
	var _view_w = camera_get_view_width(view_camera[0]);	//Pega o tamanho da camera horintal
	var _view_h = camera_get_view_height(view_camera[0]);	//Pega o tamanho da camera vertical
	var _cam_x	= x - _view_w / 2;							//Centraliza a camera horizontalmente
	var _cam_y	= y - _view_h / 2;							//Centraliza a camera verticalmente
	_cam_x		= clamp(_cam_x, 0, room_width - _view_w);	//Trava a camera para não "sair" da room no eixo X
	_cam_y		= clamp(_cam_y, 0, room_height - _view_h);	//Trava a camera para não "sair" da room no eixo Y
	camera_set_view_pos(view_camera[0], _cam_x, _cam_y);	//Define a posição da camera
	x = lerp(x, alvo.x, .1);								//Segue o player no eixo X
	y = lerp(y, alvo.y, .1);								//Segue o player no eixo Y
}

//Para a camera se o player nao existir
segue_nada = function() {
	alvo = noone;	
}

//Define o estado para seguir o player
estado = segue_player;
