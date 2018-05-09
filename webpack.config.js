// Bring in everything needed for the build.
var webpack           = require('webpack');
var merge             = require('webpack-merge');
var CopyWebpackPlugin = require('copy-webpack-plugin');
var MiniCssExtractPlugin = require("mini-css-extract-plugin");
var WebpackHtmlPlugin = require( 'html-webpack-plugin' );
var UglifyJsPlugin = require('uglifyjs-webpack-plugin');
var CompressionPlugin = require('compression-webpack-plugin');

// Setup the environment.
var path                  = require('path');
var env                   = process.env.NODE_ENV || 'development';
var staticBuild           = env === 'production' || env === 'test';
var staticBuildPublicPath = process.env.ASSET_HOST || '/';

// Common configuration
var commonConfig = {
  mode: env,

  entry: {
    app: './app/js/app.js'
  },

  output: {
    path: path.resolve(__dirname) + '/dist',
  },

  resolve: {
    modules: [
      'node_modules',
      'app'
    ],
    extensions: [
      '*',
      '.js',
      '.elm',
      '.scss'
    ]
  },

  plugins: [
    new webpack.DefinePlugin({
      __PROD: staticBuild,
      __DEV: !staticBuild
    }),
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      'window.jQuery': 'jquery',
      Hammer: 'hammerjs/hammer'
    }),
    new WebpackHtmlPlugin({
      chunks: ['app'],
      template: 'app/html/app.pug',
      filename: 'index.html',
    })
  ],

  module: {
    noParse: /\.elm$/,

    rules: [
      // JS/ES6 Loader
      {
        test: /\.js$/,
        enforce: 'pre',
        exclude: /node_modules/,
        use: [
          {
            loader: `jshint-loader`,
            options: {
              camelcase: true,
              emitErrors: false,
              failOnHint: false
            }
          }
        ]
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        options: {
          presets: [
            ['es2015', { modules: false }]
          ]
        }
      }
    ]
  }
};

// Development configuration
var devConfig = {
  devtool: 'cheap-module-eval-source-map',
  devServer: {
    contentBase: path.resolve(__dirname) + '/app/static'
  },
  output: {
    filename: 'assets/js/[name].js',
    publicPath: 'http://localhost:8080/'
  },
  module: {
    rules: [
      // CSS Loader
      {
        test: /\.(css|scss)$/,
        loaders: [
          'style-loader',
          'css-loader',
          'sass-loader?includePaths[]=' + path.resolve(__dirname) + '/node_modules'
        ]
      },
      // Elm Loader
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-hot-loader!elm-webpack-loader?warn=true&debug=true'
      },
      // Pug (Slim)
      {
        test: /\.pug$/,
        use: [
          {
            loader: 'source-loader'
          },
          {
            loader: 'pug-static-loader',
            options: {
              pretty: true,
              locals: {
                api_url: 'http://localhost:4000'
              }
            }
          }
        ]
      },
      // Font loaders
      {
        test: /\.(woff|woff2)(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader?limit=10000&mimetype=application/font-woff&name=app/fonts/[name].[ext]'
      },
      {
        test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader?limit=10000&mimetype=application/octet-stream&name=app/fonts/[name].[ext]'
      },
      {
        test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'file-loader?name=app/fonts/[name].[ext]'
      },
      // SVG loader
      {
        test: /(.*)\.svg(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader?limit=10000&mimetype=image/svg+xml&name=app/svgs/[name].[ext]'
      },
      // Image loader
      {
        test: /(.*)\.(jpe?g|png|gif)$/,
        loader: 'file-loader?name=app/images/[name].[ext]'
      }
    ]
  }
};

// Production configuration
var staticBuildConfig     = {
  output: {
    filename: 'assets/js/[name]-[hash].js',
    publicPath: staticBuildPublicPath,
  },
  plugins: [
    new webpack.optimize.OccurrenceOrderPlugin(),
    new webpack.NoEmitOnErrorsPlugin(),
    new CopyWebpackPlugin([{ from: './app/static' }]),
    new MiniCssExtractPlugin({
      filename: 'assets/css/[name]-[hash].css'
    }),
    // Breaks things.
    // new webpack.optimize.UglifyJsPlugin(),
    new webpack.optimize.AggressiveMergingPlugin(),
    new CompressionPlugin({
      asset: '[path].gz[query]',
      algorithm: 'gzip',
      test: /\.js$|\.css$|\.(svg|woff|woff2|ttf|eot)$/,
      threshold: 10240,
      minRatio: 0.8
    })
  ],
  module: {
    rules: [
      // CSS Loader - Extract CSS into files.
      {
        test: /\.(css|scss)$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader?root=..',
          'sass-loader?root=..&includePaths[]=' + path.resolve(__dirname) + '/node_modules'
        ]
      },
      // Elm Loader
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack-loader?warn=true'
      },
      // Pug (Slim)
      {
        test: /\.pug$/,
        use: [
          {
            loader: 'source-loader'
          },
          {
            loader: 'pug-static-loader',
            options: {
              pretty: false,
              locals: {
                api_url: process.env.API_URL || '/'
              }
            }
          }
        ]
      },
      // Font loaders
      {
        test: /\.(woff|woff2)(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader?limit=10000&mimetype=application/font-woff&name=assets/fonts/[name]-[hash].[ext]'
      },
      {
        test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader?limit=10000&mimetype=application/octet-stream&name=assets/fonts/[name]-[hash].[ext]'
      },
      {
        test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'file-loader?name=assets/fonts/[name]-[hash].[ext]'
      },
      // SVG loader
      {
        test: /(.*)\.svg(\?v=\d+\.\d+\.\d+)?$/,
        loader: 'url-loader?limit=10000&mimetype=image/svg+xml&name=assets/svgs/[name]-[hash].[ext]'
      },
      // Image loader
      {
        test: /(.*)\.(jpe?g|png|gif)$/,
        loader: 'file-loader?name=assets/images/[name]-[hash].[ext]'
      }
    ]
  },
  optimization: {
    minimizer: [
      new UglifyJsPlugin({
        sourceMap: true,
        uglifyOptions: {
          compress: {
            inline: false,
          },
        },
      }),
    ],
  }
};

module.exports = merge(commonConfig, staticBuild ? staticBuildConfig : devConfig);
