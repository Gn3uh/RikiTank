-- 
-- @file Ground.lua
-- This file is a part of RikiTank project, an amazing tank game !
-- Copyright (C) 2012  Riki-Team
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- 

--
-- Ici on dessine le terrain
--
function GroundLoad()
   Ground1 = love.graphics.newImage("Images/Ground1.png")
end

function GroundDraw()
   width = love.graphics.getWidth( ) / 128
   height = love.graphics.getHeight( ) / 128
   start2 = 0
   for i = 0, width do
      start = 0
      for j = 0, height do
	 love.graphics.draw(Ground1, start2, start)
	 start = start + 128
      end
      start2 = start2 + 128
   end
end