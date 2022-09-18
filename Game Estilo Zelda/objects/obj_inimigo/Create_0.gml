/// @description Insert description here

//Herda os eventos do objeto pai
event_inherited();

#region Variáveis
max_vel			= 2;				//Velocidade máxima
tempo_estado	= room_speed * 3;	//Tempo em que fica em um estado
tempo			= tempo_estado;		//Timer de estado
campo_visao		= 150;				//Distância que o inimigo "encherga" o player
tempo_persegue	= room_speed * 2;	//Tempo que leva até perseguir o player após o ataque
t_persegue		= tempo_persegue;	//Timer do persegue o player
tempo_ataque	= room_speed * .5;	//Tempo que carrega o ataque
t_ataque		= tempo_ataque;		//Timer do tempo de ataque
destino_x		= 0;				//Destino no eixo X
destino_y		= 0;				//Destino no eixo Y
alvo			= noone;			//Alvo inicial é nenhum
estado			= "parado";			//Controla o estado
debug			= false;			//Debug
image_speed		= 8 / room_speed;

#endregion

#region Funções
//Função para controlar a sprite
controla_sprite = function() {
	var _dir	= point_direction(0, 0, velh, velv);
	var _face	= _dir div 90; 
	show_debug_message(_face);
	switch(_face) {
		case 0:
			sprite_index = spr_cogumelo_right;
			image_xscale = 1;
			break;
			
		case 1:
			sprite_index = spr_cogumelo_up;
			break;
		
		case 2:
			sprite_index = spr_cogumelo_right;
			image_xscale = -1;
			break;
			
		case 3:
			sprite_index = spr_cogumelo_down;
			break;
	}	
}

//Debug para alterar o estado 
muda_estado = function() {
	var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
	var _mouse_click = mouse_check_button_released(mb_right);
	if (_mouse_sobre && _mouse_click) {
		estado = get_string("Digite o estado", "parado");	
	}	
}
	
//Define o campo de visão do player
olhando = function() {
	var _player = collision_circle(x, y, campo_visao, obj_player, false, true);
	
	if (_player && t_persegue <= 0) {	//Se o player estiver no campo de visão e o tempo for menor do que 0
		estado	= "persegue";			//Muda para o estado perseguir
		alvo	= _player;				//E o playe estiver no campo de visão ele vira o alvo
	}
}

//Máquina de estados
controla_estado = function() {
	switch(estado) {
		
		#region Parado
		case "parado":
		
			image_speed = 6 /room_speed; //Velocidade da animação
		
			image_blend = c_white;	//Cor do inimigo quando parado
			
			if (t_persegue > 0 ) t_persegue--;	//Se o tempo for maior diminui o tempo
			
			tempo--;	//Diminui o tempo que pode perseguir o player
			velh = 0;	//Velocidade horizontal
			velv = 0;	//Velocidade vertical
			
			if (tempo <= 0) {							//Se o tempo for menor ou igual a zero
				estado	= choose("parado", "andando");	//Troca o estado e escolhe entre parado e andando
				tempo	= tempo_estado;					//Tempo volta a ser o tempo de estado
			}
			
			olhando();	//Chama a função de olhar para o player
		break;
		#endregion
		
		#region Andando
		case "andando":
		
			image_speed = 8 /room_speed; //Velocidade da animação
		
			image_blend = c_white;	//Cor do inimigo quando esta andando
			
			if (t_persegue > 0 ) t_persegue--;	//Se o tempo for maior diminui o tempo
			
			tempo--;	//Diminui o tempo que pode perseguir o player
			
			var _dist = point_distance(x, y, destino_x, destino_y);				
			if (destino_x == 0 || destino_y == 0 || _dist < max_vel * 2) {	//Define uma distância aleatória
				destino_x = irandom_range(0, room_width);					//Em X
				destino_y = irandom_range(0, room_height);					//Em Y
			}
			
			var _dir	= point_direction(x, y, destino_x, destino_y);	//Vai em uma direção aleatória
			velh		= lengthdir_x(max_vel, _dir);					//Velocidade horizontal	
			velv		= lengthdir_y(max_vel, _dir);					//Velocidade vertical
			
			if (place_meeting(x + velh, y + velv, obj_chao)) {			//Se colidir 
				estado = "parado";										//Volta para o estado parado
				tempo		= tempo_estado;								//Volta o tempo para mudar de estado ao padrão
				destino_x	= 0;										//Zera o destino X
				destino_y	= 0;										//Zera o destino Y
			}
			
			if (tempo <= 0) {											//Quando o tempo de estado zera
				tempo		= tempo_estado;								//O tempo volta ao padrão
				estado		= choose("parado", "andando", "andando");	//Escolhe um novo estado
				destino_x	= 0;										//Novo destino em X
				destino_y	= 0;										//Novo destino em Y
			}
			olhando();	//Chama a função para olhar o player
		break;
		#endregion
		
		#region Persegue o player
		case "persegue":
		
			image_speed = 12 /room_speed; //Velocidade da Animação
		
			image_blend = c_orange;	//Cor do inimigo no estado persegue
			
			if (alvo) {				//Quando o alvo for o player 
				destino_x = alvo.x;	//Persegue no eixo X
				destino_y = alvo.y;	//Persegue no eixo Y
			}
			else {														//Quando não tem um alvo
				estado		= choose("parado", "parado", "andando");	//Escolhe um novo estado 
				destino_x	= 0;										//Zera o destino X
				destino_y	= 0;										//Zera o destino Y
				tempo		= tempo_estado;								//Volta o tempo para o padrão
			}
			
			var _dir	= point_direction(x, y, destino_x, destino_y);	//Define a direção
			velh		= lengthdir_x(max_vel, _dir);					//Velocidade horizontal
			velv		= lengthdir_y(max_vel, _dir);					//Velocidade vertical
			
			var _dist	= point_distance(x, y, destino_x, destino_y);	//Define a distância
			if (_dist > campo_visao * 1.5) {							//Se o player se afastar
				alvo		= noone;									//Perde o alvo
				tempo		= tempo_estado;								//Volta o tempo para mudar de estado ao padrão
				destino_x	= 0;										//Zera o destino X
				destino_y	= 0;										//Zera o destino Y
			}
			
			if (_dist < campo_visao /3) {					//Se a distância for pequena 
				estado		= "carrega ataque";	//Muda para o estado de carregar ataque
				tempo		= tempo_estado;		//Volta o tempo para o padrão
			}
		break;		
		#endregion 
		
		#region Carrega ataque
		case "carrega ataque":
		
			t_ataque--;	//Diminui o tempo de ataque
			velh = 0;	//Zera a velocidade horizontal
			velv = 0;	//Zera a velocidade vertical
			
			var _green	= (t_ataque / tempo_ataque) * 79;	//Cria um efeito na cor verde
			var _blue	= (t_ataque / tempo_ataque) * 96;	//Cria um efeito na cor azul
			
			image_blend = make_color_rgb(255, _green, _blue);	//Define a cor do inimigo
			
			if (t_ataque <= 0) {			//Quando o tempo de ataque chega em zero
				estado		= "ataque";		//Muda para o estado de ataque
				t_ataque	= tempo_ataque;	//Volta o tempo de para o padrão
			}
		break;
		#endregion
		
		#region Ataque
		case "ataque":
		
			image_blend = c_red;			//Define a cor
			t_persegue	= tempo_persegue;	//Volta o tempo para o padrão
			
			var _dir	= point_direction(x, y, destino_x, destino_y);	//Define a direção do ataque
			velh		= lengthdir_x(max_vel * 3, _dir);				//Velocidade de ataque horintal	
			velv		= lengthdir_y(max_vel * 3, _dir);				//Velocidade de ataque vertical
				
			var _dist	= point_distance(x, y, destino_x, destino_y);	//Define a distância
			if (_dist < 16) {											//Se menor que 16 pixels
				estado	= "parado";										//Muda para o estado parado
			}
		break;
		#endregion
	}
}
#endregion