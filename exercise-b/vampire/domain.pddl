(define (domain vampire)
    (:requirements :conditional-effects :negative-preconditions)
    (:predicates
        (light-on ?r)
        (slayer-is-alive)
        (slayer-is-in ?r)
        (vampire-is-alive)
        (vampire-is-in ?r)
        (fighting)
        ;
        ; static predicates
        (NEXT-ROOM ?r ?rn)
        (CONTAINS-GARLIC ?r)
    )

    (:action toggle-light
        :parameters (?anti-clockwise-neighbor ?room ?clockwise-neighbor)
        :precondition (and
            (NEXT-ROOM ?anti-clockwise-neighbor ?room)
            (NEXT-ROOM ?room ?clockwise-neighbor)
            (not (fighting))
        )
        :effect (and
            (when (and (vampire-is-in ?room) (slayer-is-in ?room)) (fighting))
            (when (not(light-on ?room)) (light-on ?room))
            (when (light-on ?room) (not(light-on ?room)))
            (when (vampire-is-in ?room) 
                (and 
                    (not (vampire-is-in ?room))
                    (when (not(light-on ?anti-clockwise-neighbor)) (vampire-is-in ?anti-clockwise-neighbor))
                    (when (light-on ?anti-clockwise-neighbor) (vampire-is-in ?clockwise-neighbor))
                )
            )
            (when (slayer-is-in ?room) 
                (and
                    (not (slayer-is-in ?room))
                    (when (light-on ?clockwise-neighbor) (slayer-is-in ?clockwise-neighbor))
                    (when (not(light-on ?clockwise-neighbor)) (slayer-is-in ?anti-clockwise-neighbor))
                )
            )
        )
    )
        
    (:action watch-fight
        :parameters (?room)
        :precondition (and
            (slayer-is-in ?room)
            (slayer-is-alive)
            (vampire-is-in ?room)
            (vampire-is-alive)
            (fighting)
        )
        :effect (and
            (not(fighting))
            (when (light-on ?room) (not(vampire-is-alive)))
            (when (CONTAINS-GARLIC ?room) (not(vampire-is-alive)))
            (when (and (not (light-on ?room)) (not (CONTAINS-GARLIC ?room))) (not (slayer-is-alive)))
        )
    )
)
