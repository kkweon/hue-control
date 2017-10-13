const path = require("path");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
    node: {
        fs: 'empty',
        net: 'empty',
        tls: 'empty',
        dgram: 'empty',
    },
    entry: "./src/index.js",
    output: {
        path: path.resolve(__dirname, "public"),
        filename: "bundle.js"
    },
    plugins: [new HtmlWebpackPlugin({
            template: "./src/html/index.html",
            inject: "body"
        }),

        new ExtractTextPlugin("style.css"),
        new CopyWebpackPlugin([{
            from: "src/static",
            to: "static"
        }])
    ],
    module: {
        rules: [{
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                use: [{
                    loader: "elm-webpack-loader",
                    options: {
                        forceWatch: true
                    }
                }]
            },
            {
                test: /\.js$/,
                exclude: [/elm-stuff/, /node_modules/],
                use: [{
                    loader: "babel-loader",
                    options: {
                        presets: ["env"]
                    }
                }]
            },
            {
                test: /\.css$/,
                use: ExtractTextPlugin.extract({
                    fallback: "style-loader",
                    use: ["css-loader", "postcss-loader"]
                })
            },
            {
                test: /\.scss$/,
                exclude: [/node_modules/],
                use: ExtractTextPlugin.extract({
                    fallback: 'style-loader',
                    //resolve-url-loader may be chained before sass-loader if necessary
                    use: ['css-loader', 'postcss-loader', 'sass-loader']
                })
            }
        ]
    },
    devServer: {
        contentBase: path.resolve(__dirname, "build"),
        port: 9000
    }
};
