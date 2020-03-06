/*
 * Copyright 2004-2020 Hewlett Packard Enterprise Development LP
 * Other additional copyright holders may be indicated within.
 *
 * The entirety of this work is licensed under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 *
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/* 
  This module contains the implementation of the heap type.

  Push or pop an element of a heap is O(lgN) in the worst case, where N is the size of the heap.
*/
module Heap {
  writeln("New library: Heap");

  private use HaltWrappers;
  private use List;

  record heap {

    /* The type of the elements contained in this heap. */
    type eltType;

    pragma "no doc"
    var _data: list(eltType) = nil;

    /* If `true`, this heap will perform parallel safe operations. */
    param parSafe = false;

    /* If `true`, this heap is a min-heap. */
    param reverse = false;

    /*
      Initializes an empty heap with `eltType`

      :arg eltType: The type of the elements

      :arg reverse: If `true`, this heap is a min-heap.
      :type reverse: `param bool`

      :arg parSafe: If `true`, this heap will use parallel safe operations.
      :type parSafe: `param bool`
    */
    proc init(type eltType, param reverse=false, param parSafe=false) {
      this.eltType = eltType;
      this._data = new list(eltType);
    }

    /*
      Return the size of the heap.
    */
    proc size():int {
      return _data.size();
    }

    /*
      Return whether the heap is empty.
    */
    proc isEmpty():bool {
      return _data.isEmpty();
    }

    /*
      Return the top element of the heap.
    */
    proc top(): eltType {
      if (boundsChecking && isEmpty()) {
        boundsCheckHalt("Called \"heap.top\" on an empty heap.");
      }
      return _data(1);
    }

    /*
      helper procs to maintain the Heap
    */
    pragma "no doc"
    proc _up(pos:int) {
      while (pos != 1) {
        var parent = pos / 2;
        if (_data[parent] < _data[pos]) {
          _data[parent] <=> _data[pos];
          pos = parent;
        }
        else break;
      }
    }

    pragma "no doc"
    proc _down(pos:int) {
      while (pos <= _data.size()) {
        // find the child node with greater value
        var greaterChild = pos*2;
        if (greaterChild > _data.size()) then break; // reach leaf node, break
        if (greaterChild + 1 <= _data.size()) {
          // if the right child node exists
          if (_data[greaterChild+1] > _data[greaterChild]) {
            // if the right child is greater, then update the greaterChild
            greaterChild += 1;
          }
        }
        // if the greaterChild's value is greater than current node, then swap and continue
        if (_data[greaterChild] > _data[pos]) {
          _data[greaterChild] <=> _data[pos];
          pos = greaterChild;
        }
        else break;
      }
    }

    /*
      Push an element into the heap

      :arg element: The element that will be pushed
    */
    proc push(element:eltType) {
      _data.append(element);
      _up(_data.size());
    }

    /*
      Pop an element.

        .. note::
          This procedure do not return the element.

    */
    proc pop() {
      if (boundsChecking && isEmpty()) {
        boundsCheckHalt("Called \"heap.pop\" on an empty heap.");
      }
      _data(1) <=> _data(_data.size());
      _data.pop();
      _down(1);
    }
  }
}
