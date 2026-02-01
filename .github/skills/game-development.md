# Game Development Guidelines

You are a Minecraft plugin development master specializing in Bukkit, Spigot, and Paper server APIs with deep knowledge of internal mechanics and modern development patterns.

## Core Expertise

### API Mastery

- Event-driven architecture with listener priorities and custom events
- Modern Paper API features (Adventure, MiniMessage, Lifecycle API)
- Command systems using Brigadier framework and tab completion
- Inventory GUI systems with NBT manipulation
- World generation and chunk management
- Entity AI and pathfinding customization

### Internal Mechanics

- NMS (net.minecraft.server) internals and Mojang mappings
- Packet manipulation and protocol handling
- Reflection patterns for cross-version compatibility
- Paperweight-userdev for deobfuscated development
- Custom entity implementations and behaviors
- Server tick optimization and timing analysis

### Performance Engineering

- Hot event optimization (PlayerMoveEvent, BlockPhysicsEvent)
- Async operations for I/O and database queries
- Chunk loading strategies and region file management
- Memory profiling and garbage collection tuning
- Thread pool management and concurrent collections
- Spark profiler integration for production debugging

### Ecosystem Integration

- Vault, PlaceholderAPI, ProtocolLib advanced usage
- Database systems (MySQL, Redis, MongoDB) with HikariCP
- Message queue integration for network communication
- Web API integration and webhook systems
- Cross-server synchronization patterns
- Docker deployment and Kubernetes orchestration

## Development Philosophy

1. **Research First**: Always use WebSearch for current best practices and existing solutions
2. **Architecture Matters**: Design with SOLID principles and design patterns
3. **Performance Critical**: Profile before optimizing, measure impact
4. **Version Awareness**: Detect server type (Bukkit/Spigot/Paper) and use appropriate APIs
5. **Modern When Possible**: Use modern APIs when available, with fallbacks for compatibility
6. **Test Everything**: Unit tests with MockBukkit, integration tests on real servers

## Technical Approach

### Project Analysis

- Examine build configuration for dependencies and target versions
- Identify existing patterns and architectural decisions
- Assess performance requirements and scalability needs
- Review security implications and attack vectors

### Implementation Strategy

- Start with minimal viable functionality
- Layer in features with proper separation of concerns
- Implement comprehensive error handling and recovery
- Add metrics and monitoring hooks
- Document with JavaDoc and user guides

### Quality Standards

- Follow Google Java Style Guide
- Implement defensive programming practices
- Use immutable objects and builder patterns
- Apply dependency injection where appropriate
- Maintain backward compatibility when possible

## Output Excellence

### Code Structure

- Clean package organization by feature
- Service layer for business logic
- Repository pattern for data access
- Factory pattern for object creation
- Event bus for internal communication

### Configuration

- YAML with detailed comments and examples
- Version-appropriate text formatting (MiniMessage for Paper, legacy for Bukkit/Spigot)
- Gradual migration paths for config updates
- Environment variable support for containers
- Feature flags for experimental functionality

### Build System

- Maven/Gradle with proper dependency management
- Shade/shadow for dependency relocation
- Multi-module projects for version abstraction
- CI/CD integration with automated testing
- Semantic versioning and changelog generation

### Documentation

- Comprehensive README with quick start
- Wiki documentation for advanced features
- API documentation for developer extensions
- Migration guides for version updates
- Performance tuning guidelines

Always leverage WebSearch and WebFetch to ensure best practices and find existing solutions. Research API changes, version differences, and community patterns before implementing. Prioritize maintainable, performant code that respects server resources and player experience.

These guidelines provide practices for game development.

## Godot Gdscript Patterns

# Godot GDScript Patterns

Production patterns for Godot 4.x game development with GDScript, covering architecture, signals, scenes, and optimization.

## When to Use This Skill

- Building games with Godot 4
- Implementing game systems in GDScript
- Designing scene architecture
- Managing game state
- Optimizing GDScript performance
- Learning Godot best practices

## Core Concepts

### 1. Godot Architecture

```
Node: Base building block
├── Scene: Reusable node tree (saved as .tscn)
├── Resource: Data container (saved as .tres)
├── Signal: Event communication
└── Group: Node categorization
```

### 2. GDScript Basics

```gdscript
class_name Player
extends CharacterBody2D

# Signals
signal health_changed(new_health: int)
signal died

# Exports (Inspector-editable)
@export var speed: float = 200.0
@export var max_health: int = 100
@export_range(0, 1) var damage_reduction: float = 0.0
@export_group("Combat")
@export var attack_damage: int = 10
@export var attack_cooldown: float = 0.5

# Onready (initialized when ready)
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var hitbox: Area2D = $Hitbox

# Private variables (convention: underscore prefix)
var _health: int
var _can_attack: bool = true

func _ready() -> void:
    _health = max_health

func _physics_process(delta: float) -> void:
    var direction := Input.get_vector("left", "right", "up", "down")
    velocity = direction * speed
    move_and_slide()

func take_damage(amount: int) -> void:
    var actual_damage := int(amount * (1.0 - damage_reduction))
    _health = max(_health - actual_damage, 0)
    health_changed.emit(_health)

    if _health <= 0:
        died.emit()
```

## Patterns

### Pattern 1: State Machine

```gdscript
# state_machine.gd
class_name StateMachine
extends Node

signal state_changed(from_state: StringName, to_state: StringName)

@export var initial_state: State

var current_state: State
var states: Dictionary = {}

func _ready() -> void:
    # Register all State children
    for child in get_children():
        if child is State:
            states[child.name] = child
            child.state_machine = self
            child.process_mode = Node.PROCESS_MODE_DISABLED

    # Start initial state
    if initial_state:
        current_state = initial_state
        current_state.process_mode = Node.PROCESS_MODE_INHERIT
        current_state.enter()

func _process(delta: float) -> void:
    if current_state:
        current_state.update(delta)

func _physics_process(delta: float) -> void:
    if current_state:
        current_state.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
    if current_state:
        current_state.handle_input(event)

func transition_to(state_name: StringName, msg: Dictionary = {}) -> void:
    if not states.has(state_name):
        push_error("State '%s' not found" % state_name)
        return

    var previous_state := current_state
    previous_state.exit()
    previous_state.process_mode = Node.PROCESS_MODE_DISABLED

    current_state = states[state_name]
    current_state.process_mode = Node.PROCESS_MODE_INHERIT
    current_state.enter(msg)

    state_changed.emit(previous_state.name, current_state.name)
```

```gdscript
# state.gd
class_name State
extends Node

var state_machine: StateMachine

func enter(_msg: Dictionary = {}) -> void:
    pass

func exit() -> void:
    pass

func update(_delta: float) -> void:
    pass

func physics_update(_delta: float) -> void:
    pass

func handle_input(_event: InputEvent) -> void:
    pass
```

```gdscript
# player_idle.gd
class_name PlayerIdle
extends State

@export var player: Player

func enter(_msg: Dictionary = {}) -> void:
    player.animation.play("idle")

func physics_update(_delta: float) -> void:
    var direction := Input.get_vector("left", "right", "up", "down")

    if direction != Vector2.ZERO:
        state_machine.transition_to("Move")

func handle_input(event: InputEvent) -> void:
    if event.is_action_pressed("attack"):
        state_machine.transition_to("Attack")
    elif event.is_action_pressed("jump"):
        state_machine.transition_to("Jump")
```

### Pattern 2: Autoload Singletons

```gdscript
# game_manager.gd (Add to Project Settings > Autoload)
extends Node

signal game_started
signal game_paused(is_paused: bool)
signal game_over(won: bool)
signal score_changed(new_score: int)

enum GameState { MENU, PLAYING, PAUSED, GAME_OVER }

var state: GameState = GameState.MENU
var score: int = 0:
    set(value):
        score = value
        score_changed.emit(score)

var high_score: int = 0

func _ready() -> void:
    process_mode = Node.PROCESS_MODE_ALWAYS
    _load_high_score()

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("pause") and state == GameState.PLAYING:
        toggle_pause()

func start_game() -> void:
    score = 0
    state = GameState.PLAYING
    game_started.emit()

func toggle_pause() -> void:
    var is_paused := state != GameState.PAUSED

    if is_paused:
        state = GameState.PAUSED
        get_tree().paused = true
    else:
        state = GameState.PLAYING
        get_tree().paused = false

    game_paused.emit(is_paused)

func end_game(won: bool) -> void:
    state = GameState.GAME_OVER

    if score > high_score:
        high_score = score
        _save_high_score()

    game_over.emit(won)

func add_score(points: int) -> void:
    score += points

func _load_high_score() -> void:
    if FileAccess.file_exists("user://high_score.save"):
        var file := FileAccess.open("user://high_score.save", FileAccess.READ)
        high_score = file.get_32()

func _save_high_score() -> void:
    var file := FileAccess.open("user://high_score.save", FileAccess.WRITE)
    file.store_32(high_score)
```

```gdscript
# event_bus.gd (Global signal bus)
extends Node

# Player events
signal player_spawned(player: Node2D)
signal player_died(player: Node2D)
signal player_health_changed(health: int, max_health: int)

# Enemy events
signal enemy_spawned(enemy: Node2D)
signal enemy_died(enemy: Node2D, position: Vector2)

# Item events
signal item_collected(item_type: StringName, value: int)
signal powerup_activated(powerup_type: StringName)

# Level events
signal level_started(level_number: int)
signal level_completed(level_number: int, time: float)
signal checkpoint_reached(checkpoint_id: int)
```

### Pattern 3: Resource-based Data

```gdscript
# weapon_data.gd
class_name WeaponData
extends Resource

@export var name: StringName
@export var damage: int
@export var attack_speed: float
@export var range: float
@export_multiline var description: String
@export var icon: Texture2D
@export var projectile_scene: PackedScene
@export var sound_attack: AudioStream
```

```gdscript
# character_stats.gd
class_name CharacterStats
extends Resource

signal stat_changed(stat_name: StringName, new_value: float)

@export var max_health: float = 100.0
@export var attack: float = 10.0
@export var defense: float = 5.0
@export var speed: float = 200.0

# Runtime values (not saved)
var _current_health: float

func _init() -> void:
    _current_health = max_health

func get_current_health() -> float:
    return _current_health

func take_damage(amount: float) -> float:
    var actual_damage := maxf(amount - defense, 1.0)
    _current_health = maxf(_current_health - actual_damage, 0.0)
    stat_changed.emit("health", _current_health)
    return actual_damage

func heal(amount: float) -> void:
    _current_health = minf(_current_health + amount, max_health)
    stat_changed.emit("health", _current_health)

func duplicate_for_runtime() -> CharacterStats:
    var copy := duplicate() as CharacterStats
    copy._current_health = copy.max_health
    return copy
```

```gdscript
# Using resources
class_name Character
extends CharacterBody2D

@export var base_stats: CharacterStats
@export var weapon: WeaponData

var stats: CharacterStats

func _ready() -> void:
    # Create runtime copy to avoid modifying the resource
    stats = base_stats.duplicate_for_runtime()
    stats.stat_changed.connect(_on_stat_changed)

func attack() -> void:
    if weapon:
        print("Attacking with %s for %d damage" % [weapon.name, weapon.damage])

func _on_stat_changed(stat_name: StringName, value: float) -> void:
    if stat_name == "health" and value <= 0:
        die()
```

### Pattern 4: Object Pooling

```gdscript
# object_pool.gd
class_name ObjectPool
extends Node

@export var pooled_scene: PackedScene
@export var initial_size: int = 10
@export var can_grow: bool = true

var _available: Array[Node] = []
var _in_use: Array[Node] = []

func _ready() -> void:
    _initialize_pool()

func _initialize_pool() -> void:
    for i in initial_size:
        _create_instance()

func _create_instance() -> Node:
    var instance := pooled_scene.instantiate()
    instance.process_mode = Node.PROCESS_MODE_DISABLED
    instance.visible = false
    add_child(instance)
    _available.append(instance)

    # Connect return signal if exists
    if instance.has_signal("returned_to_pool"):
        instance.returned_to_pool.connect(_return_to_pool.bind(instance))

    return instance

func get_instance() -> Node:
    var instance: Node

    if _available.is_empty():
        if can_grow:
            instance = _create_instance()
            _available.erase(instance)
        else:
            push_warning("Pool exhausted and cannot grow")
            return null
    else:
        instance = _available.pop_back()

    instance.process_mode = Node.PROCESS_MODE_INHERIT
    instance.visible = true
    _in_use.append(instance)

    if instance.has_method("on_spawn"):
        instance.on_spawn()

    return instance

func _return_to_pool(instance: Node) -> void:
    if not instance in _in_use:
        return

    _in_use.erase(instance)

    if instance.has_method("on_despawn"):
        instance.on_despawn()

    instance.process_mode = Node.PROCESS_MODE_DISABLED
    instance.visible = false
    _available.append(instance)

func return_all() -> void:
    for instance in _in_use.duplicate():
        _return_to_pool(instance)
```

```gdscript
# pooled_bullet.gd
class_name PooledBullet
extends Area2D

signal returned_to_pool

@export var speed: float = 500.0
@export var lifetime: float = 5.0

var direction: Vector2
var _timer: float

func on_spawn() -> void:
    _timer = lifetime

func on_despawn() -> void:
    direction = Vector2.ZERO

func initialize(pos: Vector2, dir: Vector2) -> void:
    global_position = pos
    direction = dir.normalized()
    rotation = direction.angle()

func _physics_process(delta: float) -> void:
    position += direction * speed * delta

    _timer -= delta
    if _timer <= 0:
        returned_to_pool.emit()

func _on_body_entered(body: Node2D) -> void:
    if body.has_method("take_damage"):
        body.take_damage(10)
    returned_to_pool.emit()
```

### Pattern 5: Component System

```gdscript
# health_component.gd
class_name HealthComponent
extends Node

signal health_changed(current: int, maximum: int)
signal damaged(amount: int, source: Node)
signal healed(amount: int)
signal died

@export var max_health: int = 100
@export var invincibility_time: float = 0.0

var current_health: int:
    set(value):
        var old := current_health
        current_health = clampi(value, 0, max_health)
        if current_health != old:
            health_changed.emit(current_health, max_health)

var _invincible: bool = false

func _ready() -> void:
    current_health = max_health

func take_damage(amount: int, source: Node = null) -> int:
    if _invincible or current_health <= 0:
        return 0

    var actual := mini(amount, current_health)
    current_health -= actual
    damaged.emit(actual, source)

    if current_health <= 0:
        died.emit()
    elif invincibility_time > 0:
        _start_invincibility()

    return actual

func heal(amount: int) -> int:
    var actual := mini(amount, max_health - current_health)
    current_health += actual
    if actual > 0:
        healed.emit(actual)
    return actual

func _start_invincibility() -> void:
    _invincible = true
    await get_tree().create_timer(invincibility_time).timeout
    _invincible = false
```

```gdscript
# hitbox_component.gd
class_name HitboxComponent
extends Area2D

signal hit(hurtbox: HurtboxComponent)

@export var damage: int = 10
@export var knockback_force: float = 200.0

var owner_node: Node

func _ready() -> void:
    owner_node = get_parent()
    area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
    if area is HurtboxComponent:
        var hurtbox := area as HurtboxComponent
        if hurtbox.owner_node != owner_node:
            hit.emit(hurtbox)
            hurtbox.receive_hit(self)
```

```gdscript
# hurtbox_component.gd
class_name HurtboxComponent
extends Area2D

signal hurt(hitbox: HitboxComponent)

@export var health_component: HealthComponent

var owner_node: Node

func _ready() -> void:
    owner_node = get_parent()

func receive_hit(hitbox: HitboxComponent) -> void:
    hurt.emit(hitbox)

    if health_component:
        health_component.take_damage(hitbox.damage, hitbox.owner_node)
```

### Pattern 6: Scene Management

```gdscript
# scene_manager.gd (Autoload)
extends Node

signal scene_loading_started(scene_path: String)
signal scene_loading_progress(progress: float)
signal scene_loaded(scene: Node)
signal transition_started
signal transition_finished

@export var transition_scene: PackedScene
@export var loading_scene: PackedScene

var _current_scene: Node
var _transition: CanvasLayer
var _loader: ResourceLoader

func _ready() -> void:
    _current_scene = get_tree().current_scene

    if transition_scene:
        _transition = transition_scene.instantiate()
        add_child(_transition)
        _transition.visible = false

func change_scene(scene_path: String, with_transition: bool = true) -> void:
    if with_transition:
        await _play_transition_out()

    _load_scene(scene_path)

func change_scene_packed(scene: PackedScene, with_transition: bool = true) -> void:
    if with_transition:
        await _play_transition_out()

    _swap_scene(scene.instantiate())

func _load_scene(path: String) -> void:
    scene_loading_started.emit(path)

    # Check if already loaded
    if ResourceLoader.has_cached(path):
        var scene := load(path) as PackedScene
        _swap_scene(scene.instantiate())
        return

    # Async loading
    ResourceLoader.load_threaded_request(path)

    while true:
        var progress := []
        var status := ResourceLoader.load_threaded_get_status(path, progress)

        match status:
            ResourceLoader.THREAD_LOAD_IN_PROGRESS:
                scene_loading_progress.emit(progress[0])
                await get_tree().process_frame
            ResourceLoader.THREAD_LOAD_LOADED:
                var scene := ResourceLoader.load_threaded_get(path) as PackedScene
                _swap_scene(scene.instantiate())
                return
            _:
                push_error("Failed to load scene: %s" % path)
                return

func _swap_scene(new_scene: Node) -> void:
    if _current_scene:
        _current_scene.queue_free()

    _current_scene = new_scene
    get_tree().root.add_child(_current_scene)
    get_tree().current_scene = _current_scene

    scene_loaded.emit(_current_scene)
    await _play_transition_in()

func _play_transition_out() -> void:
    if not _transition:
        return

    transition_started.emit()
    _transition.visible = true

    if _transition.has_method("transition_out"):
        await _transition.transition_out()
    else:
        await get_tree().create_timer(0.3).timeout

func _play_transition_in() -> void:
    if not _transition:
        transition_finished.emit()
        return

    if _transition.has_method("transition_in"):
        await _transition.transition_in()
    else:
        await get_tree().create_timer(0.3).timeout

    _transition.visible = false
    transition_finished.emit()
```

### Pattern 7: Save System

```gdscript
# save_manager.gd (Autoload)
extends Node

const SAVE_PATH := "user://savegame.save"
const ENCRYPTION_KEY := "your_secret_key_here"

signal save_completed
signal load_completed
signal save_error(message: String)

func save_game(data: Dictionary) -> void:
    var file := FileAccess.open_encrypted_with_pass(
        SAVE_PATH,
        FileAccess.WRITE,
        ENCRYPTION_KEY
    )

    if file == null:
        save_error.emit("Could not open save file")
        return

    var json := JSON.stringify(data)
    file.store_string(json)
    file.close()

    save_completed.emit()

func load_game() -> Dictionary:
    if not FileAccess.file_exists(SAVE_PATH):
        return {}

    var file := FileAccess.open_encrypted_with_pass(
        SAVE_PATH,
        FileAccess.READ,
        ENCRYPTION_KEY
    )

    if file == null:
        save_error.emit("Could not open save file")
        return {}

    var json := file.get_as_text()
    file.close()

    var parsed := JSON.parse_string(json)
    if parsed == null:
        save_error.emit("Could not parse save data")
        return {}

    load_completed.emit()
    return parsed

func delete_save() -> void:
    if FileAccess.file_exists(SAVE_PATH):
        DirAccess.remove_absolute(SAVE_PATH)

func has_save() -> bool:
    return FileAccess.file_exists(SAVE_PATH)
```

```gdscript
# saveable.gd (Attach to saveable nodes)
class_name Saveable
extends Node

@export var save_id: String

func _ready() -> void:
    if save_id.is_empty():
        save_id = str(get_path())

func get_save_data() -> Dictionary:
    var parent := get_parent()
    var data := {"id": save_id}

    if parent is Node2D:
        data["position"] = {"x": parent.position.x, "y": parent.position.y}

    if parent.has_method("get_custom_save_data"):
        data.merge(parent.get_custom_save_data())

    return data

func load_save_data(data: Dictionary) -> void:
    var parent := get_parent()

    if data.has("position") and parent is Node2D:
        parent.position = Vector2(data.position.x, data.position.y)

    if parent.has_method("load_custom_save_data"):
        parent.load_custom_save_data(data)
```

## Performance Tips

```gdscript
# 1. Cache node references
@onready var sprite := $Sprite2D  # Good
# $Sprite2D in _process()  # Bad - repeated lookup

# 2. Use object pooling for frequent spawning
# See Pattern 4

# 3. Avoid allocations in hot paths
var _reusable_array: Array = []

func _process(_delta: float) -> void:
    _reusable_array.clear()  # Reuse instead of creating new

# 4. Use static typing
func calculate(value: float) -> float:  # Good
    return value * 2.0

# 5. Disable processing when not needed
func _on_off_screen() -> void:
    set_process(false)
    set_physics_process(false)
```

## Best Practices

### Do's

- **Use signals for decoupling** - Avoid direct references
- **Type everything** - Static typing catches errors
- **Use resources for data** - Separate data from logic
- **Pool frequently spawned objects** - Avoid GC hitches
- **Use Autoloads sparingly** - Only for truly global systems

### Don'ts

- **Don't use `get_node()` in loops** - Cache references
- **Don't couple scenes tightly** - Use signals
- **Don't put logic in resources** - Keep them data-only
- **Don't ignore the Profiler** - Monitor performance
- **Don't fight the scene tree** - Work with Godot's design

## Resources

- [Godot Documentation](https://docs.godotengine.org/en/stable/)
- [GDQuest Tutorials](https://www.gdquest.com/)
- [Godot Recipes](https://kidscancode.org/godot_recipes/)

## Unity Ecs Patterns

# Unity ECS Patterns

Production patterns for Unity's Data-Oriented Technology Stack (DOTS) including Entity Component System, Job System, and Burst Compiler.

## When to Use This Skill

- Building high-performance Unity games
- Managing thousands of entities efficiently
- Implementing data-oriented game systems
- Optimizing CPU-bound game logic
- Converting OOP game code to ECS
- Using Jobs and Burst for parallelization

## Core Concepts

### 1. ECS vs OOP

| Aspect      | Traditional OOP   | ECS/DOTS        |
| ----------- | ----------------- | --------------- |
| Data layout | Object-oriented   | Data-oriented   |
| Memory      | Scattered         | Contiguous      |
| Processing  | Per-object        | Batched         |
| Scaling     | Poor with count   | Linear scaling  |
| Best for    | Complex behaviors | Mass simulation |

### 2. DOTS Components

```
Entity: Lightweight ID (no data)
Component: Pure data (no behavior)
System: Logic that processes components
World: Container for entities
Archetype: Unique combination of components
Chunk: Memory block for same-archetype entities
```

## Patterns

### Pattern 1: Basic ECS Setup

```csharp
using Unity.Entities;
using Unity.Mathematics;
using Unity.Transforms;
using Unity.Burst;
using Unity.Collections;

// Component: Pure data, no methods
public struct Speed : IComponentData
{
    public float Value;
}

public struct Health : IComponentData
{
    public float Current;
    public float Max;
}

public struct Target : IComponentData
{
    public Entity Value;
}

// Tag component (zero-size marker)
public struct EnemyTag : IComponentData { }
public struct PlayerTag : IComponentData { }

// Buffer component (variable-size array)
[InternalBufferCapacity(8)]
public struct InventoryItem : IBufferElementData
{
    public int ItemId;
    public int Quantity;
}

// Shared component (grouped entities)
public struct TeamId : ISharedComponentData
{
    public int Value;
}
```

### Pattern 2: Systems with ISystem (Recommended)

```csharp
using Unity.Entities;
using Unity.Transforms;
using Unity.Mathematics;
using Unity.Burst;

// ISystem: Unmanaged, Burst-compatible, highest performance
[BurstCompile]
public partial struct MovementSystem : ISystem
{
    [BurstCompile]
    public void OnCreate(ref SystemState state)
    {
        // Require components before system runs
        state.RequireForUpdate<Speed>();
    }

    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        float deltaTime = SystemAPI.Time.DeltaTime;

        // Simple foreach - auto-generates job
        foreach (var (transform, speed) in
            SystemAPI.Query<RefRW<LocalTransform>, RefRO<Speed>>())
        {
            transform.ValueRW.Position +=
                new float3(0, 0, speed.ValueRO.Value * deltaTime);
        }
    }

    [BurstCompile]
    public void OnDestroy(ref SystemState state) { }
}

// With explicit job for more control
[BurstCompile]
public partial struct MovementJobSystem : ISystem
{
    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        var job = new MoveJob
        {
            DeltaTime = SystemAPI.Time.DeltaTime
        };

        state.Dependency = job.ScheduleParallel(state.Dependency);
    }
}

[BurstCompile]
public partial struct MoveJob : IJobEntity
{
    public float DeltaTime;

    void Execute(ref LocalTransform transform, in Speed speed)
    {
        transform.Position += new float3(0, 0, speed.Value * DeltaTime);
    }
}
```

### Pattern 3: Entity Queries

```csharp
[BurstCompile]
public partial struct QueryExamplesSystem : ISystem
{
    private EntityQuery _enemyQuery;

    public void OnCreate(ref SystemState state)
    {
        // Build query manually for complex cases
        _enemyQuery = new EntityQueryBuilder(Allocator.Temp)
            .WithAll<EnemyTag, Health, LocalTransform>()
            .WithNone<Dead>()
            .WithOptions(EntityQueryOptions.FilterWriteGroup)
            .Build(ref state);
    }

    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        // SystemAPI.Query - simplest approach
        foreach (var (health, entity) in
            SystemAPI.Query<RefRW<Health>>()
                .WithAll<EnemyTag>()
                .WithEntityAccess())
        {
            if (health.ValueRO.Current <= 0)
            {
                // Mark for destruction
                SystemAPI.GetSingleton<EndSimulationEntityCommandBufferSystem.Singleton>()
                    .CreateCommandBuffer(state.WorldUnmanaged)
                    .DestroyEntity(entity);
            }
        }

        // Get count
        int enemyCount = _enemyQuery.CalculateEntityCount();

        // Get all entities
        var enemies = _enemyQuery.ToEntityArray(Allocator.Temp);

        // Get component arrays
        var healths = _enemyQuery.ToComponentDataArray<Health>(Allocator.Temp);
    }
}
```

### Pattern 4: Entity Command Buffers (Structural Changes)

```csharp
// Structural changes (create/destroy/add/remove) require command buffers
[BurstCompile]
[UpdateInGroup(typeof(SimulationSystemGroup))]
public partial struct SpawnSystem : ISystem
{
    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        var ecbSingleton = SystemAPI.GetSingleton<BeginSimulationEntityCommandBufferSystem.Singleton>();
        var ecb = ecbSingleton.CreateCommandBuffer(state.WorldUnmanaged);

        foreach (var (spawner, transform) in
            SystemAPI.Query<RefRW<Spawner>, RefRO<LocalTransform>>())
        {
            spawner.ValueRW.Timer -= SystemAPI.Time.DeltaTime;

            if (spawner.ValueRO.Timer <= 0)
            {
                spawner.ValueRW.Timer = spawner.ValueRO.Interval;

                // Create entity (deferred until sync point)
                Entity newEntity = ecb.Instantiate(spawner.ValueRO.Prefab);

                // Set component values
                ecb.SetComponent(newEntity, new LocalTransform
                {
                    Position = transform.ValueRO.Position,
                    Rotation = quaternion.identity,
                    Scale = 1f
                });

                // Add component
                ecb.AddComponent(newEntity, new Speed { Value = 5f });
            }
        }
    }
}

// Parallel ECB usage
[BurstCompile]
public partial struct ParallelSpawnJob : IJobEntity
{
    public EntityCommandBuffer.ParallelWriter ECB;

    void Execute([EntityIndexInQuery] int index, in Spawner spawner)
    {
        Entity e = ECB.Instantiate(index, spawner.Prefab);
        ECB.AddComponent(index, e, new Speed { Value = 5f });
    }
}
```

### Pattern 5: Aspect (Grouping Components)

```csharp
using Unity.Entities;
using Unity.Transforms;
using Unity.Mathematics;

// Aspect: Groups related components for cleaner code
public readonly partial struct CharacterAspect : IAspect
{
    public readonly Entity Entity;

    private readonly RefRW<LocalTransform> _transform;
    private readonly RefRO<Speed> _speed;
    private readonly RefRW<Health> _health;

    // Optional component
    [Optional]
    private readonly RefRO<Shield> _shield;

    // Buffer
    private readonly DynamicBuffer<InventoryItem> _inventory;

    public float3 Position
    {
        get => _transform.ValueRO.Position;
        set => _transform.ValueRW.Position = value;
    }

    public float CurrentHealth => _health.ValueRO.Current;
    public float MaxHealth => _health.ValueRO.Max;
    public float MoveSpeed => _speed.ValueRO.Value;

    public bool HasShield => _shield.IsValid;
    public float ShieldAmount => HasShield ? _shield.ValueRO.Amount : 0f;

    public void TakeDamage(float amount)
    {
        float remaining = amount;

        if (HasShield && _shield.ValueRO.Amount > 0)
        {
            // Shield absorbs damage first
            remaining = math.max(0, amount - _shield.ValueRO.Amount);
        }

        _health.ValueRW.Current = math.max(0, _health.ValueRO.Current - remaining);
    }

    public void Move(float3 direction, float deltaTime)
    {
        _transform.ValueRW.Position += direction * _speed.ValueRO.Value * deltaTime;
    }

    public void AddItem(int itemId, int quantity)
    {
        _inventory.Add(new InventoryItem { ItemId = itemId, Quantity = quantity });
    }
}

// Using aspect in system
[BurstCompile]
public partial struct CharacterSystem : ISystem
{
    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        float dt = SystemAPI.Time.DeltaTime;

        foreach (var character in SystemAPI.Query<CharacterAspect>())
        {
            character.Move(new float3(1, 0, 0), dt);

            if (character.CurrentHealth < character.MaxHealth * 0.5f)
            {
                // Low health logic
            }
        }
    }
}
```

### Pattern 6: Singleton Components

```csharp
// Singleton: Exactly one entity with this component
public struct GameConfig : IComponentData
{
    public float DifficultyMultiplier;
    public int MaxEnemies;
    public float SpawnRate;
}

public struct GameState : IComponentData
{
    public int Score;
    public int Wave;
    public float TimeRemaining;
}

// Create singleton on world creation
public partial struct GameInitSystem : ISystem
{
    public void OnCreate(ref SystemState state)
    {
        var entity = state.EntityManager.CreateEntity();
        state.EntityManager.AddComponentData(entity, new GameConfig
        {
            DifficultyMultiplier = 1.0f,
            MaxEnemies = 100,
            SpawnRate = 2.0f
        });
        state.EntityManager.AddComponentData(entity, new GameState
        {
            Score = 0,
            Wave = 1,
            TimeRemaining = 120f
        });
    }
}

// Access singleton in system
[BurstCompile]
public partial struct ScoreSystem : ISystem
{
    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        // Read singleton
        var config = SystemAPI.GetSingleton<GameConfig>();

        // Write singleton
        ref var gameState = ref SystemAPI.GetSingletonRW<GameState>().ValueRW;
        gameState.TimeRemaining -= SystemAPI.Time.DeltaTime;

        // Check exists
        if (SystemAPI.HasSingleton<GameConfig>())
        {
            // ...
        }
    }
}
```

### Pattern 7: Baking (Converting GameObjects)

```csharp
using Unity.Entities;
using UnityEngine;

// Authoring component (MonoBehaviour in Editor)
public class EnemyAuthoring : MonoBehaviour
{
    public float Speed = 5f;
    public float Health = 100f;
    public GameObject ProjectilePrefab;

    class Baker : Baker<EnemyAuthoring>
    {
        public override void Bake(EnemyAuthoring authoring)
        {
            var entity = GetEntity(TransformUsageFlags.Dynamic);

            AddComponent(entity, new Speed { Value = authoring.Speed });
            AddComponent(entity, new Health
            {
                Current = authoring.Health,
                Max = authoring.Health
            });
            AddComponent(entity, new EnemyTag());

            if (authoring.ProjectilePrefab != null)
            {
                AddComponent(entity, new ProjectilePrefab
                {
                    Value = GetEntity(authoring.ProjectilePrefab, TransformUsageFlags.Dynamic)
                });
            }
        }
    }
}

// Complex baking with dependencies
public class SpawnerAuthoring : MonoBehaviour
{
    public GameObject[] Prefabs;
    public float Interval = 1f;

    class Baker : Baker<SpawnerAuthoring>
    {
        public override void Bake(SpawnerAuthoring authoring)
        {
            var entity = GetEntity(TransformUsageFlags.Dynamic);

            AddComponent(entity, new Spawner
            {
                Interval = authoring.Interval,
                Timer = 0f
            });

            // Bake buffer of prefabs
            var buffer = AddBuffer<SpawnPrefabElement>(entity);
            foreach (var prefab in authoring.Prefabs)
            {
                buffer.Add(new SpawnPrefabElement
                {
                    Prefab = GetEntity(prefab, TransformUsageFlags.Dynamic)
                });
            }

            // Declare dependencies
            DependsOn(authoring.Prefabs);
        }
    }
}
```

### Pattern 8: Jobs with Native Collections

```csharp
using Unity.Jobs;
using Unity.Collections;
using Unity.Burst;
using Unity.Mathematics;

[BurstCompile]
public struct SpatialHashJob : IJobParallelFor
{
    [ReadOnly]
    public NativeArray<float3> Positions;

    // Thread-safe write to hash map
    public NativeParallelMultiHashMap<int, int>.ParallelWriter HashMap;

    public float CellSize;

    public void Execute(int index)
    {
        float3 pos = Positions[index];
        int hash = GetHash(pos);
        HashMap.Add(hash, index);
    }

    int GetHash(float3 pos)
    {
        int x = (int)math.floor(pos.x / CellSize);
        int y = (int)math.floor(pos.y / CellSize);
        int z = (int)math.floor(pos.z / CellSize);
        return x * 73856093 ^ y * 19349663 ^ z * 83492791;
    }
}

[BurstCompile]
public partial struct SpatialHashSystem : ISystem
{
    private NativeParallelMultiHashMap<int, int> _hashMap;

    public void OnCreate(ref SystemState state)
    {
        _hashMap = new NativeParallelMultiHashMap<int, int>(10000, Allocator.Persistent);
    }

    public void OnDestroy(ref SystemState state)
    {
        _hashMap.Dispose();
    }

    [BurstCompile]
    public void OnUpdate(ref SystemState state)
    {
        var query = SystemAPI.QueryBuilder()
            .WithAll<LocalTransform>()
            .Build();

        int count = query.CalculateEntityCount();

        // Resize if needed
        if (_hashMap.Capacity < count)
        {
            _hashMap.Capacity = count * 2;
        }

        _hashMap.Clear();

        // Get positions
        var positions = query.ToComponentDataArray<LocalTransform>(Allocator.TempJob);
        var posFloat3 = new NativeArray<float3>(count, Allocator.TempJob);

        for (int i = 0; i < count; i++)
        {
            posFloat3[i] = positions[i].Position;
        }

        // Build hash map
        var hashJob = new SpatialHashJob
        {
            Positions = posFloat3,
            HashMap = _hashMap.AsParallelWriter(),
            CellSize = 10f
        };

        state.Dependency = hashJob.Schedule(count, 64, state.Dependency);

        // Cleanup
        positions.Dispose(state.Dependency);
        posFloat3.Dispose(state.Dependency);
    }
}
```

## Performance Tips

```csharp
// 1. Use Burst everywhere
[BurstCompile]
public partial struct MySystem : ISystem { }

// 2. Prefer IJobEntity over manual iteration
[BurstCompile]
partial struct OptimizedJob : IJobEntity
{
    void Execute(ref LocalTransform transform) { }
}

// 3. Schedule parallel when possible
state.Dependency = job.ScheduleParallel(state.Dependency);

// 4. Use ScheduleParallel with chunk iteration
[BurstCompile]
partial struct ChunkJob : IJobChunk
{
    public ComponentTypeHandle<Health> HealthHandle;

    public void Execute(in ArchetypeChunk chunk, int unfilteredChunkIndex,
        bool useEnabledMask, in v128 chunkEnabledMask)
    {
        var healths = chunk.GetNativeArray(ref HealthHandle);
        for (int i = 0; i < chunk.Count; i++)
        {
            // Process
        }
    }
}

// 5. Avoid structural changes in hot paths
// Use enableable components instead of add/remove
public struct Disabled : IComponentData, IEnableableComponent { }
```

## Best Practices

### Do's

- **Use ISystem over SystemBase** - Better performance
- **Burst compile everything** - Massive speedup
- **Batch structural changes** - Use ECB
- **Profile with Profiler** - Identify bottlenecks
- **Use Aspects** - Clean component grouping

### Don'ts

- **Don't use managed types** - Breaks Burst
- **Don't structural change in jobs** - Use ECB
- **Don't over-architect** - Start simple
- **Don't ignore chunk utilization** - Group similar entities
- **Don't forget disposal** - Native collections leak

## Resources

- [Unity DOTS Documentation](https://docs.unity3d.com/Packages/com.unity.entities@latest)
- [Unity DOTS Samples](https://github.com/Unity-Technologies/EntityComponentSystemSamples)
- [Burst User Guide](https://docs.unity3d.com/Packages/com.unity.burst@latest)
