

// Boost DFS example on an undirected graph.
// Create a sample graph, traverse its nodes
// in DFS order and print out their values.

#include <boost/graph/adjacency_list.hpp>
#include <boost/graph/depth_first_search.hpp>
#include <iostream>
#include <deque>
using namespace std;

typedef boost::adjacency_list<boost::listS, boost::vecS, boost::directedS> MyGraph;
typedef boost::graph_traits<MyGraph>::vertex_descriptor MyVertex;
typedef boost::graph_traits<MyGraph>::edge_descriptor MyEdge;

struct finish_dfs{};

class MyVisitor : public boost::default_dfs_visitor
{
public:
  MyVisitor(const MyVertex &v) : start(v) {}

  void discover_vertex(MyVertex v, const MyGraph& g)
  {
    std::cout << "\n" << v ;
    workvertex.push_back(v);
    return;
  }

  void back_edge(MyEdge e, const MyGraph& g) const
  {
      std::cout << " back_edge" << e ;
      return;
  }

  void forward_or_cross_edge(MyEdge e, const MyGraph& g) const
  {
      cout << " forward_or_cross_edge" << e ;
      return;
  }


  void finish_vertex(MyVertex v, const MyGraph& g)
  {
      workvertex.pop_back();
//      std::cout << " finish_vertex" << v ;
      if (v == start) throw finish_dfs();
  }
  MyVertex start;

  std::deque<MyVertex> workvertex;

};

int main()
{
    cout << "--------------\n";
    {

        typedef std::pair < int, int >E;
        E edge_array[] = {
            E(1, 2), E(2, 1),
            E(3,2),
            E(4,3),
            E(2, 5), E(5, 2),
            E(3, 6),
            E(7, 8), E(8, 7),
            E(8, 5), E(5, 8),
            E(5, 6), E(6, 5),
            E(6, 9), E(9, 6),
            E(5, 10), E(10, 5),
            E(6,11),
            E(10,11),
            E(11,12),
            E(10,13), E(13,10),
            E(9,12), E(12,9),
            E(4, 9), E(9, 4),
            E(14,15), E(15,14),
            E(16,17), E(17,16)
        };
        MyGraph g1(edge_array, edge_array + sizeof(edge_array) / sizeof(E), 18);
        MyVertex v = 5;
        MyVisitor vis(v);


        typedef std::map<MyVertex, boost::default_color_type> ColorMap;
        ColorMap cmap;
        boost::associative_property_map<ColorMap> c(cmap);



        try {
            boost::depth_first_search(g1, boost::visitor(vis).color_map(c).root_vertex(v));
        }
        catch(finish_dfs &) {
            std::cout << "end of search\n";
            // noop
        } catch (boost::exception const& ex) {
            (void)ex;
            throw;
        } catch (std::exception &e) {
            (void)e;
            throw;
        } catch (...) {
            throw;
        }
        std::cout << '\n';
        return 0;
    }
};

