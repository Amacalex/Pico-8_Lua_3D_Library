pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
--game loop
--[[
_init() functions
----------------------------
1.) set_cam(fov,camera_eye)
  a.) must draw first 
2.)
    create_tri_player
    (
      (types:vec3's) 
      {
        (types:numbers) {x=<vert_1>,y=<vert_2>,z=<vert_3>},
        (types:numbers) {x=<vert_4>,y=<vert_5>,z=<vert_6>},
        (types:numbers) {x=<vert_7>,y=<vert_8>,z=<vert_9>},
        ...
      },
      (type: number) <mass>,
      (type: number) <x_fric>,
      (type: number) <y_fric>,
      (type: number) <z_fric>
    )


_update() functions
-------------------------------
1.) cls() 
  a.) should draw first
2.) move_player((type: number) <force>)

_draw() functions
-------------------------------
1.) draw_obj(
      (types:vec3's) 
    {
      (types:numbers) p1={x=<vert_1>,y=<vert_2>,z=<vert_3>},
      (types:numbers) p2={x=<vert_4>,y=<vert_5>,z=<vert_6>},
      (types:numbers) p3={x=<vert_7>,y=<vert_8>,z=<vert_9>},
      ...
    },
      (type:number) <color>,
      (type:vec3) 
      {
        (type:number) x=<player_x>,
        (type:number) y=<player_y>,
        (type:number) z=<player_z>
      }
]]
function _init()
  
  --(fov,camera_eye)
  set_cam(vec3(0,0,0),112,-0.004,1,10,vec3(.9,.9,.9))
  player_obj = create_player_obj(move_player)
  
  --[[create_tri_player
    ((types:vec3's) 
    {
      (types:numbers) p1={x=<vert_1>,y=<vert_2>,z=<vert_3>},
      (types:numbers) p2={x=<vert_4>,y=<vert_5>,z=<vert_6>},
      (types:numbers) p3={x=<vert_7>,y=<vert_8>,z=<vert_9>},
      ...
    }
    ,mass,x_fric,y_fric,z_fric)
  ]]
  
  ply_1_obj = player_obj.init(
    tri(
          vec3(100, -20, 2),
          vec3(80, 20, 2), 
          vec3(120 ,20, 2) 
       ),
    11,0.9,0.9,0.8)
  
  temp_tris,tris_pos_a  = cube(vec3(0,0,0),20)
  tris_a = cube_2_tris(temp_tris)
  --tris_b = cube_2_tris(cube(vec3(70,0,90),20))
end

function _update60()
  
  --move_player(force)  
  player_obj.update(ply_1_obj,2,-1)
end

function _draw()
  --[[
    draw_player_obj(vertices,color,world_position)
  ]]
  cls()
  --[[
  player_obj.draw
  (
    ply_1_obj.verts,
    11,
    {
      x=ply_1_obj.x,
      y=ply_1_obj.y,
      z=ply_1_obj.z
    }
  )
  ]]
  draw_cubes(tris_a,11,vec3(0,0,0))
  --draw_cubes(tris_b,11,vec3(0,0,0))
end

-->8
--player

function create_game_obj(_update,_draw)
  local game_obj =
  {
    init= _init,
    update= _update,
    draw= _draw
  }
  return game_obj
end

function create_player_obj(movement_controller)
  local player_obj =
  {
    init=create_tri_player,
    update=movement_controller,
    draw=draw_tri
  }
  return player_obj
end

function create_tri_player(vertices,_mass,fric_x,fric_y,fric_z)
  local _player = 
  {
    timer = 0,
    on_ground = false,
    mass = _mass,
    x=0,
    y=0,
    z=0,
    verts = vertices,
    fric = player_friction(fric_x,fric_y,fric_z)
  }
  return _player
end

function player_friction(fric_x,fric_y,fric_z)
  local _fric = 
  {
    x = fric_x,
    y = fric_y,
    z = fric_z
  }
  return _fric
end

function move_player(p_obj,_ground)
  if btn(0) then
    cam.sx = cam.sx - cam.force/cam.mass
  elseif btn(1) then
    cam.sx = cam.sx + cam.force/cam.mass
  end

  if(cam.y > _ground+20 and p_obj.timer > 45) then
    cam.sy = cam.sy - .45
    cam.on_ground = true
  elseif btn(4) and p_obj.timer > 45 then
    cam.sy = cam.sy + 5
    cam.timer = 0
    cam.on_ground = false
  elseif (cam.on_ground) then
    cam.sy = 0
    cam.timer = 0
  end

  if btn(2) then
    cam.sz = cam.sz + cam.force/cam.mass
  elseif btn(3) then
    cam.sz = cam.sz - cam.force/cam.mass
  end

  cam.sx = cam.sx * cam.fric.x
  cam.sy = cam.sy * cam.fric.y
  cam.sz = cam.sz * cam.fric.z
  
  cam.x = cam.x + cam.sx
  cam.y = cam.y + cam.sy
  cam.z = cam.z + cam.sz

  p_obj.timer = p_obj.timer + 1
end

-->8
--shapes
function cube(translate,_scale)
  local position = translate
  local _cube =
  {
    vec3(-1.0, -1.0, -1.0),
		vec3(-1.0, -1.0, 1.0),
		vec3(-1.0, 1.0, -1.0),
		vec3(-1.0, -1.0, -1.0),
		vec3(-1.0, 1.0, -1.0),
		vec3(1.0, -1.0, -1.0),
		vec3(-1.0, -1.0, -1.0),
		vec3(1.0, -1.0, -1.0),
		vec3(-1.0, -1.0, 1.0),
		vec3(-1.0, -1.0, 1.0),
		vec3(-1.0, 1.0, 1.0),
		vec3(-1.0, 1.0, -1.0),
		vec3(-1.0, -1.0, 1.0),
		vec3(1.0, -1.0, -1.0),
		vec3(1.0, -1.0, 1.0),
		vec3(-1.0, -1.0, 1.0),
		vec3(1.0, -1.0, 1.0),
		vec3(1.0, 1.0, 1.0),
		vec3(-1.0, -1.0, 1.0),
		vec3(1.0, 1.0, 1.0),
		vec3(-1.0, 1.0, 1.0),
		vec3(-1.0, 1.0, -1.0),
		vec3(-1.0, 1.0, 1.0),
		vec3(1.0, 1.0, 1.0),
		vec3(-1.0, 1.0, -1.0),
		vec3(1.0, 1.0, -1.0),
		vec3(1.0, -1.0, -1.0),
		vec3(-1.0, 1.0, -1.0),
		vec3(1.0, 1.0, 1.0),
		vec3(1.0, 1.0, -1.0),
		vec3(1.0, -1.0, -1.0),
		vec3(1.0, 1.0, -1.0),
		vec3(1.0, 1.0, 1.0),
		vec3(1.0, -1.0, -1.0),
		vec3(1.0, 1.0, 1.0),
		vec3(1.0, -1.0, 1.0)
  }

  for i=1,36 do
    _cube[i].x = _cube[i].x * _scale + translate.x
    _cube[i].y = _cube[i].y * _scale + translate.y
    _cube[i].z = _cube[i].z * _scale + translate.z
  end
  
  return _cube,position
end

function cube_2_tris(_cube)
  local _tris = {}
  for i=1,36 do
    _tris[i] = tri(_cube[i], _cube[i+1], _cube[i+2])
  end
  return _tris
end

-- (tri(vev3,vec3,vec3),col,{x,y,z}) 
function draw_cubes(_tris,_col,_dv)
--(cam.z + 10 > -_tris[i].p1.z)
  local dist_a
  dist_a = tris_pos_a.z-cam.z
  --if (dist_a < 150 ) then
    for i=1,36,4 do
      draw_tri(_tris[i],_col,_dv)  
    end
    
    
     
  print(cam.z)    
  --end
end

-- (p1=vec3,p2=vec3,p3=vec3) 
function tri(_p1,_p2,_p3)
  local _local_tri = 
  {
    p1 = _p1,
    p2 = _p2,
    p3 = _p3
  }
  return _local_tri
end

-- ( tri(vec3,vec3,vec3),x,y,z )
function translate_tri(_tri,_x,_y,_z)
  p1 = _tri.p1
  p2 = _tri.p2
  p3 = _tri.p3

  p1.x = p1.x + _x
  p2.x = p2.x + _x
  p3.x = p3.x + _x

  p1.y = p1.y - _y
  p2.y = p2.y - _y
  p3.y = p3.y - _y

  p1.z = p1.z + _z
  p2.z = p2.z + _z
  p3.z = p3.z + _z

  return tri(p1,p2,p3)
end


function draw_tri(world_tri,_col,dv)  
  local wt = translate_tri(world_tri,dv.x,dv.y,dv.z)  
  local lt = 
  {
    p1 = world_2_screen(wt.p1,vec2(64,64)),
    p2 = world_2_screen(wt.p2,vec2(64,64)),
    p3 = world_2_screen(wt.p3,vec2(64,64))
  }
  
  if lt.p1 ~=nil and lt.p2 ~= nil then  
    line(lt.p1.x,lt.p1.y,lt.p2.x,lt.p2.y,_col)
  end
  if lt.p2 ~= nil and lt.p3 ~= nil then
    line(lt.p2.x,lt.p2.y,lt.p3.x,lt.p3.y,_col)
  end
  if lt.p1 ~= nil and lt.p3 ~= nil then 
    line(lt.p3.x,lt.p3.y,lt.p1.x,lt.p1.y,_col)
  end
end

-->8
--3d perspective
function set_cam(vec,_fov,near,_force,_mass,_fric)
  cam =
  {
    x=vec.x,
    y=vec.y,
    z=vec.z,
    sx=0,
    sy=0,
    sz=0,
    mass=_mass,
    fric=_fric,
    force=_force,
    on_ground = false,
    fov = _fov,
    sz_near = near
  }
end

function vec2(_x,_y)
  local v = 
  {
    x=_x,
    y=_y
  }
  return v
end

function vec3(_x,_y,_z)
  local v =
  {
    x=_x,
    y=_y,
    z=_z
  }
  return v
end

function world_2_screen(point3d,cent)
  --create a method that converts a 3D point to a 2D point 
  local screen_2d = function(p1,p2)
    return cos(cam.fov/2)*(p1*p2)*cam.sz_near
  end

  --draw the point only if it is in front of the screen
  if
   cam.z > -point3d.z then
    local _x = screen_2d(-point3d.x+cam.x,point3d.z+cam.z)
    local _y = screen_2d(-point3d.y-cam.y,point3d.z+cam.z)
    
    return vec2(_x+cent.x,_y+cent.y)
  else
    return nil
  end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
