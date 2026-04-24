extends Control

@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var market_item_animation_component: MarketItemAnimationComponent = $MarketItemAnimationComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sub_viewport.market_item_clicked.connect(market_item_animation_component.on_click)
	sub_viewport.market_item_escaped.connect(market_item_animation_component.on_escape)
	
 
