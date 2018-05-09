// Bring in everything needed for the build.
const webpack           = require('webpack');
const merge             = require('webpack-merge');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const WebpackHtmlPlugin = require( 'html-webpack-plugin' );
const UglifyJsPlugin = require('uglifyjs-webpack-plugin');
const CompressionPlugin = require('compression-webpack-plugin');
const SentryPlugin = require('@sentry/webpack-plugin');

// Setup the environment.
const path                  = require('path');
const env                   = process.env.NODE_ENV || 'development';
const staticBuild           = env === 'production' || env === 'test';
const staticBuildPublicPath = process.env.ASSET_HOST || '/';
const herokuVersion = 'v' + (parseInt((process.env.HEROKU_RELEASE_VERSION || 'v0').substr(1)) + 1);

// Common configuration
const commonConfig = {
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
      jQuery: 'jquery'
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
const devConfig = {
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
                api_url: 'http://localhost:4000',
                sentry_dsn: process.env.SENTRY_DSN || '',
                release: process.env.HEROKU_RELEASE_VERSION || 'local-test'
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
const staticBuildConfig     = {
  devtool: 'source-map',
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
    new webpack.optimize.AggressiveMergingPlugin(),
    new CompressionPlugin({
      asset: '[path].gz[query]',
      algorithm: 'gzip',
      test: /\.js$|\.css$|\.(svg|woff|woff2|ttf|eot)$/,
      threshold: 10240,
      minRatio: 0.8
    }),
    // new SentryPlugin({
    //   release: herokuVersion,
    //   include: './dist',
    //   ignore: ['node_modules', 'webpack.config.js'],
    // })
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
                api_url: process.env.API_URL || '/',
                sentry_dsn: process.env.SENTRY_CLIENT_DSN || '',
                release: herokuVersion
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
