use serde::Deserialize;
use std::{
    fs::{read, read_to_string, OpenOptions},
    path::Path,
};
use toml::Table;
use url::Url;

#[derive(Deserialize)]
struct Config {
    general: General,
    sonarr: Sonarr,
    plex: Plex,
}

#[derive(Deserialize)]
struct General {
    log_level: u8,
    threshold: u8,
}

#[derive(Deserialize)]
struct Sonarr {
    url: Url,
    api_key: String,
}

#[derive(Deserialize)]
struct Plex {
    url: Url,
    api_key: String,
}

// parser function
fn parser(path_to_config: Path) -> Config {
    // let file_path_as_str = path_to_config.to_str().unwrap();
    // read file
    let file = read_to_string(path_to_config).unwrap();
    let file = toml::FromStr(file);
    todo!()
}
