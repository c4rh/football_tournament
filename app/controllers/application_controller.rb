class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :ensure_signup_complete, only: [:new, :create, :update, :destroy]
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def ensure_signup_complete
    # Убеждаемся, что цикл не бесконечный
    return if action_name == 'finish_signup'

    # Редирект на адрес 'finish_signup' если пользователь
    # не подтвердил свою почту
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end



  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
