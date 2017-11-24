require 'parser'
require 'msgmaker'

class KakaoController < ApplicationController
  @@keyboard= Msgmaker::Keyboard.new   ## @@ 클래스 변수선언
  @@message= Msgmaker::Message.new
  @@btn_text = ["영화", "고양이", "아무말"]
  def keyboard
    # keyboard = {
     
    #     type: 'buttons',
    #     buttons: ["영화", "Test key 2", "Test key 3"]
        
    #     # type: 'text'
     
    # }
    
    render json: @@keyboard.getBtnKey(@@btn_text)
  end
  
  def message
    
    basic_keyboard = @@keyboard.getBtnKey(@@btn_text)
    
    user_msg = params[:content]

    if user_msg == '고양이'    
      animal = Parser::Animal.new
      msg = @@message.getPicMessage("고양이 데헷",animal.cat) # url img 
    elsif user_msg == '영화'
      movie = Parser::Movie.new
      msg = @@message.getMessage(movie.naver)
    else
      msg = @@message.getMessage(user_msg)
    end
    
    result ={
      message: msg,
      keyboard: basic_keyboard
    }
    
    render json: result
  end
  
  def friend_add
    user_key = params[:user_key]
    User.create(
      user_key: user_key,
      chat_room: 1
      )
      render nothing: true
  end
  
  def friend_del
    user = User.find_by(user_key: params[:user_key])
    user.destroy
    render nothing: true
  end
  
  def chat_room
    user = User.find_by(user_key: params[:user_key])
    user.chat_room += 1
    user.save
    
    render nothing: true
  end
  

end
