// ARGS Parser
use clap::Parser;
use playarr::{format_greeting, is_verbose_mode, Args};

// main flow process:
// 1. query plex for watching
// 2. query plex for recently watched
// 3. query sonarr
// 4. update database with fresh sonarr data
// 5. compare plex watching/recently-watched with databse
// 6. prep-list of items to download
// 7. sort-by priority
// 8. smart-queue off sonarr downloads
// 9. monitor downloads with nzbget and/or sonnar

// // TUI Stuff
// use color_eyre::Result;
// use crossterm::event::{self, Event};
// use ratatui::{DefaultTerminal, Frame};

// Non-TUI Stuff
fn main() {
    let args = Args::parse();
    if is_verbose_mode(&args) {
        println!("DEBUG {args:?}");
    }
    println!("{}", format_greeting(args.name));
}

// // TUI Stuff
// fn main() -> Result<()> {
//     color_eyre::install()?;
//     let terminal = ratatui::init();
//     let result = run(terminal);
//     ratatui::restore();
//     result
// }

// fn run(mut terminal: DefaultTerminal) -> Result<()> {
//     loop {
//         terminal.draw(render)?;
//         if matches!(event::read()?, Event::Key(_)) {
//             break Ok(());
//         }
//     }
// }

// fn render(frame: &mut Frame) {
//     let args = Args::parse();
//     if args.verbose {
//         println!("DEBUG {args:?}");
//     }
//     let welcome_message = format!(
//         "Hello {} (from playarr)!",
//         args.name.unwrap_or("world".to_string())
//     );
//     frame.render_widget(welcome_message, frame.area());
// }
