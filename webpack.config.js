const path = require('path');
const fs = require('fs');
const webpack = require('webpack');
const SWPrecacheWebpackPlugin = require('sw-precache-webpack-plugin');
const VueLoaderPlugin = require('vue-loader/lib/plugin');

module.exports = {
    entry: './src/main.js',
    output: {
        path: path.resolve(__dirname, './dist'),
        publicPath: 'dist/',
        filename: 'build.js'
    },
    module: {
        rules: [
            {
                test: /\.css$/,
                use: [
                    'vue-style-loader',
                    'css-loader'
                ],
            },
            {
                test: /\.scss$/,
                use: [
                    'vue-style-loader',
                    'css-loader',
                    'sass-loader'
                ],
            },
            {
                test: /\.sass$/,
                use: [
                    'vue-style-loader',
                    'css-loader',
                    'sass-loader?indentedSyntax'
                ],
            },
            {
                test: /\.vue$/,
                use: [{
                    loader: 'vue-loader',
                    options: {
                        loaders: {
                            // Since sass-loader (weirdly) has SCSS as its default parse mode, we map
                            // the "scss" and "sass" values for the lang attribute to the right configs here.
                            // other preprocessors should work out of the box, no loader config like this necessary.
                            'scss': [
                                'vue-style-loader',
                                'css-loader',
                                'sass-loader'
                            ]
                        }
                        // other vue-loader options go here
                    }
                }]
            },
            {
                test: /\.js$/,
                loader: 'babel-loader',
                exclude: /node_modules/
            },
	        {
		        test: /\.(png|jpg|gif|svg)$/,
		        loader: 'file-loader',
		        options: {
			        name: '[name].[ext]?[hash]',
			        outputPath: 'images/',
			        publicPath: 'dist/images/'
		        }
	        },
	        {
		        test: /\.(ttf|woff|woff2|eot)$/,
		        loader: 'file-loader',
		        options: {
			        name: '[name].[ext]?[hash]',
			        outputPath:'fonts/',
			        publicPath: 'dist/fonts/'
		        }
	        }
        ]
    },
    resolve: {
        alias: {
            'vue$': 'vue/dist/vue.esm.js',
	        '@': path.resolve(__dirname, './src')
        },
        extensions: ['*', '.js', '.vue', '.json']
    },
    devServer: {
        historyApiFallback: true,
        noInfo: true,
        overlay: true,
        before: function (app) {
            app.get('dist/service-worker.js', function (req, res) {
                res.set({'Content-Type': 'application/javascript; charset=utf-8'});
                res.send(fs.readFileSync('dist/service-worker.js'));
            });
        },
        proxy: {
            '/api/': 'http://localhost:3000'
        }
    },
    performance: {
        hints: false
    },
    devtool: '#eval-source-map',
    plugins: [
        // service worker caching
        new SWPrecacheWebpackPlugin({
            cacheId: 'my-vue-app',
            filename: 'service-worker.js',
            staticFileGlobs: ['dist/**/*.{js,html,css}'],
            minify: true,
            stripPrefix: 'dist/'
        }),
        new VueLoaderPlugin()
    ]
};

if (process.env.NODE_ENV === 'production') {
    module.exports.devtool = '#source-map';
    // http://vue-loader.vuejs.org/en/workflow/production.html
    module.exports.plugins = (module.exports.plugins || []).concat([
        new webpack.DefinePlugin({
            'process.env': {
                NODE_ENV: '"production"'
            }
        }),
        new webpack.LoaderOptionsPlugin({
            minimize: true
        })
    ])
}
