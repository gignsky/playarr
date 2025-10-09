#![allow(dead_code)]
#![allow(unused_imports)]
#![allow(unused_variables)]
use clap::Parser; // ARGS Parser
use std::fs;
use std::path::Path;

mod config_parser;

#[derive(Parser, Debug)]
#[clap(author = "Maxwell Rupp", version, about)]
/// Application configuration
struct Args {
    // whether to be verbose
    // #[arg(short = 'v', long = "verbose")]
    // verbose: bool,
}

fn main() {
    let args = Args::parse();

    // Read Config
    // Define path to config file
    let config_path = Path::new("config.toml");
    // Check if config file exists
    if config_path.exists() {
        // let config =
        // determine if running as a daemon, if so loop the rest of the items
        // get plex status
        // check episodes that are watched or being watched
        // compare with threshold
        // compile list of things to download
        // send off order to download new episodes
        // save currently requested files so that they are not reordered while the files are being
        // processed
    };

    // Print the config for debugging
    // println!("Config: {:#?}", config);

    // Test connection to Plex & Sonarr
    // match config {
    //     Ok(config) => {
    //         // println!("Config: {:#?}", config);
    //         connection_tester::test_connection(config);
    //     }
    //     Err(e) => {
    //         eprintln!("ERROR: Unable to parse config file: {}", e);
    //     }
    // }
}
