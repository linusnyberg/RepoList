//
//  DataLoader.swift
//  Repo List
//
//  Created by Linus Nyberg on 2017-05-13.
//  Copyright © 2017 Linus Nyberg. All rights reserved.
//

import Foundation

enum LoadingState {
	case neverLoaded, isLoading, doneLoading
}

/// Requirements for all data loaders.
protocol DataLoader {

	weak var delegate: DataLoaderDelegate? { get set }

	/// The state of the data loader. The initial state is `neverLoaded`.
	var loadingState: LoadingState { get }

	/// Starts loading data. As data is made available, it's signalled through calls on the delegate.
	/// Note that one call to this method might result in multiple calls to delegate.dataLoaderDidLoadData()
	func startLoadingData(allowCache: Bool)
}

protocol DataLoaderDelegate: class {

	/// Called when data is loaded. Note: Might be called multiple times for one refresh action.
	func dataLoaderDidLoadData(dataLoader: DataLoader)

	// TODO: func dataLoaderFailedWithError(error: ?)
}
