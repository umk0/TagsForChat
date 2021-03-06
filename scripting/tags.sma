#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <csx>

#define PLUGIN "Tags for chat"
#define VERSION "2.1.1"
#define AUTHOR "uMk0"
new tags_num = 0;
public plugin_init() {
register_plugin(PLUGIN, VERSION, AUTHOR);//register a plugin | Регистрируем плагин

register_message(get_user_msgid("SayText"),"goChangeText");

register_cvar("tags_rank_enabled", "0");

new configsDir[64];
get_configsdir(configsDir, 63);
server_cmd("exec %s/tags.cfg", configsDir);

for(new i = 1; i <= 100; i++){
	new tmpCvar[255];
	formatex(tmpCvar, 254, "tags_flags_%d", i);
	register_cvar(tmpCvar, "false");
	new tmpnameCvar2[255],tmpCvar2[255];
		formatex(tmpnameCvar2, 254, "tags_flags_%d", i);
		get_cvar_string(tmpnameCvar2,tmpCvar2,254);
		tags_num++;
	if(equal("false",tmpCvar2)){
		tags_num--;
		break;
	}
}
register_dictionary("tags.txt");
}
public goChangeText(msgId,msgDest,msgEnt){	

    new id = get_msg_arg_int(1);//We get the id of the message sender | Получаем id отправителя сообщения
	
        if(!is_user_connected(id))return PLUGIN_HANDLED;    //Stop if the player is online | Остановка если игрок вне сети
        
		new prefixRank[255],flags_player = get_user_flags(id), string_flags[32], controlchat[256], tmpchat[256], prefix[255];
		
		if(get_cvar_num("tags_rank_enabled") == 1) getRank(id,prefixRank);
		
		get_flags(flags_player,string_flags,31);//Format the previously received flags in a row in the usual form | Форматируем ранее полученные в флаги в строку в привычном виде  
		
		for(new i = 1; i <= tags_num; i++){
			new tmpnameCvar[255],tmpCvar[255];
				formatex(tmpnameCvar, 254, "tags_flags_%d", i);
				get_cvar_string(tmpnameCvar,tmpCvar,254);
			if(equal(string_flags,tmpCvar)){
				new tmpTags[255], tmpLang[255];
				formatex(tmpLang, 254, "TAGS_%d", i);
				formatex(tmpTags, 254, "%L", LANG_PLAYER, tmpLang);
				ReplaceColorIndex(tmpTags);
				prefix = tmpTags;
				break;
			}
		}
		
		get_msg_arg_string(2,controlchat, charsmax(controlchat));//Intercept messages | Перехватываем сообщение	
		if(!equal(controlchat,"#Cstrike_Chat_All")){//check the general chat or team worked to add here and there | проверяем чат общий или командный чтобы добавление работало там и там
            //then the team chat | тут командный чат
			add(tmpchat,charsmax(tmpchat),prefixRank);//Add prefixed | Добавляем префикс
            add(tmpchat,charsmax(tmpchat),prefix);//Add prefixed | Добавляем префикс
            add(tmpchat,charsmax(tmpchat),controlchat);//And do not forget about the text :) | Ну и не забываем про текст :)
        }else{
            //тут общий чат

			add(tmpchat,charsmax(tmpchat),prefixRank);//Add prefixed | Добавляем префикс
            add(tmpchat,charsmax(tmpchat),prefix);//Add prefixed | Добавляем префикс
            add(tmpchat,charsmax(tmpchat),"^x03 %s1: ^x01%s2");//And do not forget about the text :) | Ну и не забываем про текст :)
            }
		
        set_msg_arg_string(2,tmpchat);//Send message | Отправляем наше сообщение
        return PLUGIN_CONTINUE;//КОНЕЦ!
		
		
}
public getRank(id, dest[]){
	new stats[8],bodyhits[8],irank;
	irank = get_user_stats(id,stats,bodyhits);
	formatex(dest, 254, "%L ", LANG_PLAYER, "TAGS_RANK", irank);
	ReplaceColorIndex(dest);
	return dest;
}
public ReplaceColorIndex(text[]){

	new whith[][] = {{"^x01"},{"^x03"},{"^x04"}};
	new what[][] = {{"!1"},{"!2"},{"!3"}};

	for(new i = 0; i < 3; i++){
		replace_all(text,64,what[i],whith[i]);
		}
	return text;
}

