class TeamMember
    attr_accessor :img, :data_target, :name, :rol, :country

    def initialize name,rol,country,data_target,img
        @name = name
        @rol = rol
        @country = country
        @img = img
        @data_target = data_target
    end
end
