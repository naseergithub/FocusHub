# class Ability
    # include CanCan::Ability
    # def initialize(user)
    #     can :read, Task, user_id: user.id
    #     can :create, Task
    #     can :update, Task, user_id: user.id
    #     can :destroy, Task, user_id: user.id
    # end
# end