class Ability
    include CanCan::Ability
    def initialize(user)
        can [:index, :show, :search], Task, user_id: user.id
        can :create, Task
        can :update, Task, user_id: user.id
        can :destroy, Task, user_id: user.id
        can :unauthorized, Task
    end
end