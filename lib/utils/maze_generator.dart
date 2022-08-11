// The below is the link referenced for the maze generator algorithm:
// https://github.com/john-science/mazelib/blob/main/mazelib/generate/Kruskal.py

/// Maze generator
///
/// use `MazeGenerator.generate(rows,cols)` to generate
/// a maze. Check [generate] for more details.
class MazeGenerator {
  /// generates the maze using Kruskal's algorithm
  ///
  /// - [rows] is the number of rows in the maze
  /// - [cols] is the number of columns in the maze
  ///
  /// The return is a 2d array of [List<List<bool>>] where
  /// the element with true is a wall and false is a free space.
  ///
  /// Note: The returned maze is a closed maze
  static List<List<bool>> generate(int rows, int cols) {
    // a 2d array of [rows,cols] with all values set to 1;
    final grid = <List<bool>>[];
    for (var i = 0; i < rows; i++) {
      final row = <bool>[];
      for (var j = 0; j < cols; j++) {
        row.add(true);
      }
      grid.add(row);
    }

    // remove the walls making corridors for  the maze
    final forest = <List<List<int>>>[];
    for (var i = 1; i < rows - 1; i += 2) {
      for (var j = 1; j < cols - 1; j += 2) {
        forest.add([
          [i, j]
        ]);
        grid[i][j] = false;
      }
    }

    // gather edges (walls) for the corridors (forest)
    final edges = <List<int>>[];
    for (var i = 2; i < rows - 1; i += 2) {
      for (var j = 1; j < cols - 1; j += 2) {
        edges.add([i, j]);
      }
    }
    for (var i = 1; i < rows - 1; i += 2) {
      for (var j = 2; j < cols - 1; j += 2) {
        edges.add([i, j]);
      }
    }

    // shuffle the edges
    edges.shuffle();

    // generate maze - Kruskal's algorithm
    while (forest.length > 1) {
      final cur = edges.removeAt(0);
      final curX = cur[0];
      final curY = cur[1];

      var tree1 = -1;
      var tree2 = -1;

      if (curX.isEven) {
        // even - vertical walls
        var tempSum = 0;
        for (final element in forest) {
          var flag = false;
          for (final e in element) {
            if (e[0] == curX - 1 && e[1] == curY) {
              flag = true;
            }
          }
          if (flag) {
            tempSum += forest.indexOf(element);
          }
        }
        tree1 = tempSum;
        tempSum = 0;
        for (final element in forest) {
          var flag = false;
          for (final e in element) {
            if (e[0] == curX + 1 && e[1] == curY) {
              flag = true;
            }
          }
          if (flag) {
            tempSum += forest.indexOf(element);
          }
        }
        tree2 = tempSum;
      } else {
        // odd - horizontal walls
        var tempSum = 0;
        for (final element in forest) {
          var flag = false;
          for (final e in element) {
            if (e[0] == curX && e[1] == curY - 1) {
              flag = true;
            }
          }
          if (flag) {
            tempSum += forest.indexOf(element);
          }
        }
        tree1 = tempSum;
        tempSum = 0;
        for (final element in forest) {
          var flag = false;
          for (final e in element) {
            if (e[0] == curX && e[1] == curY + 1) {
              flag = true;
            }
          }
          if (flag) {
            tempSum += forest.indexOf(element);
          }
        }
        tree2 = tempSum;
      }

      if (tree1 != tree2) {
        final newTree = forest[tree1] + forest[tree2];
        final temp1 = forest[tree1];
        final temp2 = forest[tree2];
        forest
          ..remove(temp1)
          ..remove(temp2)
          ..add(newTree);
        grid[curX][curY] = false;
      }
    }

    return grid;
  }
}
