#![allow(dead_code)]
#![allow(unused_imports)]
#![allow(unused_variables)]
use clap::Parser; // ARGS Parser
use serde::Deserialize;
use std::fs;
use std::path::Path;

mod config_parser;

#[derive(Parser, Debug)]
#[clap(author = "Maxwell Rupp", version, about)]
/// Application configuration
struct Args {
    /// whether to be verbose
    #[arg(short = 'v', long = "verbose")]
    verbose: bool,

    /// an optional name to greet
    #[arg()]
    name: Option<String>,
}

fn main() {
    let args = Args::parse();
    if args.verbose {
        println!("DEBUG {args:?}");
    }
    println!(
        "Hello {} (from playarr)!",
        args.name.unwrap_or("world".to_string())
    );

    // Define path to config file
    let config_path = Path::new("config.toml");
    let config = config_parser::read_config(Path::new(config_path));

    // Print the config for debugging
    println!("Config: {:#?}", config);
}
