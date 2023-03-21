# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  #before_action :user_state, only: [:create]
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # ログインした後の遷移先の指定
  def after_sign_in_path_for(resource)
    user_path(current_user.id)
  end

  # ログアウトした後の遷移先の指定
  def after_sign_out_path_for(resource)
    root_path
  end

   # ゲストユーザーの設定記述
  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user), notice: 'guestuserでログインしました。'
  end


  protected
    # 退会ステータスの確認メソッド
    def user_state
      @user = User.find_by(email: params[:user][:email])
      if @user
        if @user.valid_password?(params[:user][:password]) && !@user.is_deleted
          flash[:danger] = "退会済のユーザーです。"
          redirect_to new_user_session_path
        end
      end
    end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
