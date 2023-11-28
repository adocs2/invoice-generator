# frozen_string_literal: true

module User::Repository
  extend self

  AsReadonly = ->(user) { user&.tap(&:readonly!) }

  def create_user(email:, authentication_token:, activation_token:)
    ::User::Record.create(
      email: email,
      authentication_token: authentication_token,
      activation_token: activation_token,
      activated: false
    ).then(&AsReadonly)
  end

  def find_user_by_id(id)
    find_user_by(id: id) if id
  end

  def find_user_by_email(email)
    find_user_by(email: email) if email
  end

  def find_user_by_authentication_token(authentication_token)
    find_user_by(authentication_token: authentication_token) if authentication_token
  end

  def change_user_token(user, authentication_token, activation_token)
    return false unless user.persisted?

    update(
      conditions: { id: user.id },
      attributes: { authentication_token: authentication_token, activation_token: activation_token, activated: false }
    )
  end

  def activate_user(user, activation_token)
    return false unless user.activation_token == activation_token

    update(
      conditions: { id: user.id },
      attributes: { activated: true, activation_token: nil }
    )
  end

  private

  def update(conditions:, attributes:)
    attributes.merge!(updated_at: ::Time.current)

    updated = ::User::Record.where(conditions).update_all(attributes)

    updated == 1
  end

  def find_user_by(conditions)
    ::User::Record.find_by(conditions).then(&AsReadonly)
  end
end
