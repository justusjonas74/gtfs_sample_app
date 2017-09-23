module StopsHelper

    def route_icon(route)
        # Describes the type of transportation used on a route. Valid values for this field are:
        # 0: Tram, Streetcar, Light rail. Any light rail or street level system within a metropolitan area.
        # 1: Subway, Metro. Any underground rail system within a metropolitan area.
        # 2: Rail. Used for intercity or long-distance travel.
        # 3: Bus. Used for short- and long-distance bus routes.
        # 4: Ferry. Used for short- and long-distance boat service.
        # 5: Cable car. Used for street-level cable cars where the cable runs beneath the car.
        # 6: Gondola, Suspended cable car. Typically used for aerial cable cars where the car is suspended from the cable.
        # 7: Funicular. Any rail system designed for steep inclines.
        unless route.route_type == nil
            case route.route_type
            when 0
                return material_icon.tram
            when 1
                return material_icon.directions_subway
            when 2
                return material_icon.train
            when 3
                return material_icon.directions_bus
            when 4
                return material_icon.directions_boat
            when 5
                return "Cable Car"
            when 6
                return "Gondola"
            when 7
                return "Funicular"
            else
                return ""
            end
        else
            return ""
        end
    end


    def style_route(route)
        route_name = route.route_long_name.presence || route.route_short_name.presence
        return content_tag(:span, route_name, class: "badge linien-logo", style: "color: \##{route.route_text_color}; background: \##{route.route_color}")
    end

end
