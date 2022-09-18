/// @description Insert description here

//Herda os eventos do objeto pai 
event_inherited();

#region variaveis
max_vel			= 3;				//Velocidade máxima
meu_acel		= .2;				//Aceleração individual
acel			= meu_acel;			//Aceleração
roll_vel		= 5;				//Velocidade de esquiva
face			= 0;				//Controla a direçção da sprite
xscale			= 1;				//Escala em X
estado			= "parado";			//Controla o estado
estado_txt		= "parado";			//Debug do estado
debug			= false;			//Debug
attack			= false;			//Ataque do player
shield			= false;			//Defesa do player
roll			= false;			//Esquiva do player
image_ind		= 0;				//Imagem 
image_spd		= 8 / room_speed;	//Velocidade da animação
image_numb		= 1;				//Número da imagem
sprite			= sprite_index;		//Sprite do player
sprites_index	= 0;				//Sprite do array sprites
tam_sombra		= 0;

//vetor(array) para mudar as sprites do player
sprites	=	[
			//sprites parado (vetor 0)
			[spr_player_idle_right, spr_player_idle_up, spr_player_idle_right, spr_player_idle_down],
			//sprites movendo (vetor 1)
			[spr_player_run_right, spr_player_run_up, spr_player_run_right, spr_player_run_down],
			//sprites de ataque
			[spr_player_attack_right, spr_player_attack_up, spr_player_attack_right, spr_player_attack_down],
			//Sprites de defesa
			[spr_player_shield_right, spr_player_shield_up, spr_player_shield_right, spr_player_shield_down],
			//Sprites de esquiva
			[spr_player_roll_right, spr_player_roll_up, spr_player_roll_right, spr_player_roll_down]
			];
			
#endregion

#region Mapeia as teclas alternativas
keyboard_set_map(ord("W"), vk_up);		//Tecla alternativa para cima
keyboard_set_map(ord("S"), vk_down);	//Tecla alternativa para baixo
keyboard_set_map(ord("A"), vk_left);	//Tecla alternativa para esquerda
keyboard_set_map(ord("D"), vk_right);	//Tecla alternativa para direita
keyboard_set_map(ord("J"), ord("C"));	//Tecla alternativa para atacar
keyboard_set_map(ord("L"), ord("Z"));	//Tecla alternativa para defender
keyboard_set_map(ord("K"), ord("X"));	//Tecla alternativa para esquivar

#endregion

#region Funções
//Função para troca de sprites
ajusta_sprite = function(_indice_array) {
	if (sprite != sprites[_indice_array][face]) {	//Checa se a sprite em uso é a correta		
		image_ind = 0;								//Faz a animação começar do inicio
	}
	
	sprite = sprites[_indice_array][face];	//Aplica a sprite correta
	
	image_numb = sprite_get_number(sprite);	//Descobre o image number da sprite em uso
	
	image_ind += image_spd;					//Aumanta o valor da image index com base na image speed
	
	image_ind %= image_numb;				//Zera o image index quando a animação acaba
	
}

//Função para controle do player
controla_player = function() {
	
	//Teclas para movimentação e ataque
	var _up		= keyboard_check(vk_up);			//Se move para cima
	var _down	= keyboard_check(vk_down);			//Se move para baixo
	var _left	= keyboard_check(vk_left);			//Se move para esquerda
	var _right	= keyboard_check(vk_right);			//Se move para direita
	attack		= keyboard_check_pressed(ord("C"));	//Ataca
	shield		= keyboard_check(ord("Z"));			//Defende
	roll		= keyboard_check_pressed(ord("X"))	//Esquiva
	
	//Ajustando a face
	if (_up)	face	= 1;				//Sprite aponta para cima
	if (_down)	face	= 3;				//Sprite aponta para baixo
	if (_left)	{face	= 2; xscale = -1;}	//Sprite aponta para esquerda
	if (_right) {face	= 0; xscale = 1;}	//Sprite aponta para direita
	
	//Movimentação
	if ((_up xor _down) || (_left xor _right)) {									//Se uma das teclas for precionada
		var _dir		= point_direction(0, 0, (_right - _left), (_down - _up));	//Define a direção
		var _max_velh	= lengthdir_x(max_vel, _dir);								//Posição se aproxima da direção no eixo X
		var _max_velv	= lengthdir_y(max_vel, _dir);								//Posição se aproxima da direção no eixo Y
		velh			= lerp(velh, _max_velh, acel);								//Faz o efeito de aceleração no eixo X
		velv			= lerp(velv, _max_velv, acel);								//Faz o efeito de aceleração no eixo Y
	}
	else {
		velh = lerp(velh, 0, acel);		//Faz o player desacelerar em X até chegar velocidade 0 quando a tecla para de ser pressionada
		velv = lerp(velv, 0, acel);		//Faz o player desacelerar em Y até chegar velocidade 0 quando a tecla para de ser pressionada
	}
}

//controla os estados usando switch
controla_estado = function() {
	switch (estado) {
		
		#region Parado
		case "parado":
		
			controla_player();			//Chama a função para controlar o player
			estado_txt		= "parado";	//Debug
			sprites_index	= 0;		//Sprite do estado
			velh			= 0;		//Velocidade horizontal
			velv			= 0;		//Velocidade vertical
		
			//Mapeai as teclas
			var _up		= keyboard_check(vk_up);	//Cima
			var _down	= keyboard_check(vk_down);	//Bixo
			var _left	= keyboard_check(vk_left);	//Esquerda
			var _right	= keyboard_check(vk_right);	//direita
		
			//Altera a sprite baseado na direção do player
			ajusta_sprite(sprites_index);
		
			//Sai do estado parado quando se move
			if ((_up xor _down) || (_left xor _right)) {
				estado = "movendo";	
			}
		
			//Sai do estado parado quando ataca
			if (attack) {
				estado = "attack";	
			}
		
			//Sai do estado de parado quando defende
			if (shield) {
				estado = "defesa";
			}
			
			//Sai do estado de parado quando esquiva
			if (roll) {
				estado = "esquiva";	
			}
			break;
		#endregion
		
		#region Movendo
		case "movendo":
		
			controla_player();				//Chama a função para controlar o player
			estado_txt		= "movendo";	//Debug
			sprites_index	= 1;			//Sprite do estado
		
			//Altera a sprite conforme a direção do player
			ajusta_sprite(sprites_index);
			
			//Ajusta a sombra ao se mover
			if (clamp(image_ind, 1, 3) == image_ind) {
				tam_sombra = .6;	//Tamanho normal da sombra
			}
			else {
				tam_sombra = .3;	//Diminui o tamanho da sombra
			}
		
			
			//Sai do estado de movendo quando parado
			if (abs(velv) <= 0.1 && abs(velh) <= 0.1) {
				estado		= "parado";	//Vai para o estado parado
				tam_sombra	= .6;		//Volta a sombra para o tamanho normal
			}
		
			//Sai do estado de movendo quando ataca
			if (attack) {
				estado		= "attack";	//Vai para o estado ataca
				tam_sombra	= .6;		//Volta a sombra para o tamanho normal
			}
		
			//Sai do estado de movendo quando defende
			if (shield) {
				estado		= "defesa";	//Vai para o estado defesa
				tam_sombra	= .6;		//Volta a sombra para o tamanho normal
			}
			
			//Sai do estado de movendo quando esquiva
			if (roll) {
				estado		= "esquiva";	//Vai para o estado de esquiva	
				tam_sombra	= .6;			//Volta a sombra para o tamanho normal
			}
			break;
		#endregion
		
		#region Ataque
		case "attack":
		
			estado_txt = "attack";	//Debug
			
			
			ajusta_sprite(2);	//Altera a sprite do estado
			
			velh = 0;			//Zera a velocidade horizontal quando ataca
			velv = 0;			//Zera a velocidade vertical quando ataca
			
			//Volta a sprite do player parado quando a animação de ataque acaba
			if (image_ind + image_spd >= image_numb) {
				estado = "parado";	
			}
			break;
		#endregion
		
		#region Defesa
		case "defesa":
		
			estado_txt = "defesa";	//Debug
		
			controla_player();	//Chama a função para controlar o player
		
			ajusta_sprite(3);	//Altera a sprite do estado
		
			velh = 0;	//O player não se move em X quando esta no estado de defesa
			velv = 0;	//O player não se move em Y quando esta no estado de defesa
				
			//Saindo do estado de defesa
			if (!shield) {
				estado = "parado";	
			}
			break; 
		#endregion
		
		#region Esquiva
		case "esquiva":
			
			
			
			
			//Chega se ainda não entrou no estado de esquiva
			if (estado_txt != "esquiva") {	
				var _up		= keyboard_check(vk_up);			//Se move para cima
				var _down	= keyboard_check(vk_down);			//Se move para baixo
				var _left	= keyboard_check(vk_left);			//Se move para esquerda
				var _right	= keyboard_check(vk_right);			//Se move para direita
							
				if ((_up xor _down) || (_right xor _left)) {							//Se estiver se movendo esquive na direção que se move
					var _dir	= point_direction(0, 0, _right - _left, _down - _up);	//Acha a direção
					velh		= lengthdir_x(roll_vel, _dir);							//Velocidade horizontal
					velv		= lengthdir_y(roll_vel, _dir);							//Velocidade vertical
				}
				else {													//Se estiver parado esquiva na direção que esta olhando
					velh		= lengthdir_x(roll_vel, face * 90);		//Eixo X
					velv		= lengthdir_y(roll_vel, face * 90);		//Eixo Y
				}
				image_ind++;	//Pula 1 frame da animação
			}
			
			estado_txt = "esquiva";	//Debug
			
			ajusta_sprite(4); //Ajusta a sprite do player
			
			image_spd = sprite_get_number(sprite) / (room_speed /3);	//Ajusta a velocidade da animação de esquiva
			
			//Volta a sprite do player parado quando a animação de esquiva acaba
			if (image_ind + image_spd >= image_numb) {
				estado = "parado";			//Entra no estado parado
				
				image_spd = 8 / room_speed;	//Volta a velocidade de animação para o padrão
			}
		
		break;
		#endregion
	}
}

#endregion
