//- original example by [Karsten Schmidt](http://postspectacular.com)
//- toxiclibs.js by [Kyle Phillips](http://haptic-data.com)

//This example demonstrates how to use the behavior handling and specifically
//the attraction behavior to create forces around the current locations of
//particles in order to attract (or deflect) other particles nearby.
//
//Behaviors can be added and removed dynamically on both a
//global level (for the entire physics simulation) as well as for
//individual particles only.
//
//**Usage:** Click and drag mouse to attract particles


/*
 * Copyright (c) 2010 Karsten Schmidt
 *
 * This demo & library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * http://creativecommons.org/licenses/LGPL/2.1/
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

var oldX = window.screenX,
    oldY = window.screenY;
var dx = 0,dy = 0;

setInterval(function(){
},1000/60);

//**Everything below here will still work in Processing**
import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

int NUM_PARTICLES = 50;

VerletPhysics2D physics;
AttractionBehavior mouseAttractor;

Vec2D mousePos;

void setup() {
  size(innerWidth,innerHeight);
  // setup physics with 5% drag
  physics = new VerletPhysics2D();
  physics.setDrag(0.05);
  physics.setWorldBounds(new Rect(0, 0, width, height));
  
  mousePos = new Vec2D(mouseX, mouseY);// the NEW way to add gravity to the simulation, using behaviors
  mouseRepelor = new AttractionBehavior(mousePos, 25, -5 );
  mouseAttractor =new AttractionBehavior(mousePos, 50, 0.25);

  physics.addBehavior(mouseAttractor);
  physics.addBehavior(mouseRepelor);
  // physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.15)));
}

void addParticle() {
 Vec2D randLoc = Vec2D.randomVector().scale(5).addSelf(width / 2, 0);
  VerletParticle2D p = new VerletParticle2D(randLoc);
  physics.addParticle(p);
  // add a negative attraction force field around the new particle
  physics.addBehavior(new AttractionBehavior(p, 25, -5 ));
  physics.addBehavior(new AttractionBehavior(p, 50, 0.25));

}

void draw() {
  dx = oldX - window.screenX;
  dy = oldY - window.screenY;
  
  oldX = window.screenX;
  oldY = window.screenY;

  size(innerWidth,innerHeight);
  physics.setWorldBounds(new Rect(0, 0, width, height));
  background(255,0,0);
  noStroke();
  fill(255);
  if (physics.particles.length < NUM_PARTICLES) {
    addParticle();
  }
  physics.update();
  for (int i=0;i<physics.particles.length;i++) {
    VerletParticle2D p = physics.particles[i];
    p.x += dx/frameRate;
    p.y += dy/frameRate;
    // console.log(dx);
    ellipse(p.x, p.y, 25, 25);
  }
    ellipse(mouseX, mouseY, 25, 25);

  dx = 0;
  dy = 0;
  mousePos.set(mouseX, mouseY);
}

void mousePressed() {
  addParticle();
  // create a new positive attraction force field around the mouse position (radius=250px)
}

void mouseDragged() {
  addParticle();
}